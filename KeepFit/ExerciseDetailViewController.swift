
//
//  ExerciseDetailViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/24/21.
//
import UIKit
import FirebaseAuth
import Firebase

class ExerciseDetailViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet var timerDisplay: UILabel!
    @IBOutlet var startStopButton: UIButton!
    @IBOutlet weak var calorieLabel: UILabel!
    //-----------------------
    @IBOutlet weak var setrep: UILabel!

    var started = false;
    var reset = false;
    var timer = Timer()
    var trainer = Timer()
    var hour = 0
    var minute = 0
    var second = 0
    var milli = 0
    var reps = 10
    var set = 3
    var repsPassed = 0
    var secondspassed = 0.0
    var METvalue = 4.0
    var calperhour = 0.0
    var caloriecount = 0
    
    var weight = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerDisplay.text = convertToTimerDisplay(hour:0, minute: 0, second: 0, milli: 0)
        setrep.text = convertDefaultSet(set:3, rep:10)
        calorieLabel.text = convertToCalorieDisplay(calorie: 0)
        if Auth.auth().currentUser != nil {
          // User is signed in.
            print("user logged in")
            loadAccountInfo()
        }
//        else {
//          // No user is signed in.
//            performSegue(withIdentifier: "loginSegue", sender: self)
//        }
        
        calperhour = METvalue * Double(weight)
        
        print(weight)
        
        // Do any additional setup after loading the view.
    }
    
    func convertToTimerDisplay(hour: Int, minute: Int, second: Int, milli: Int) -> String {
        return "\(hour):\(minute):\(second):\(milli)"
    }
    func defaultTimer() -> String {
        return "\(0):\(0):\(0):\(0)"
    }
    func convertDefaultSet(set: Int, rep: Int) -> String {
        return "\(set)x\(rep)"
    }
    func convertToCalorieDisplay(calorie: Int) -> String {
        return "\(caloriecount) Cals"
    }
    
    //https://www.businessinsider.com/how-to-calculate-calories-burned-exercise-met-value-2017-8#:~:text=Here's%20your%20equation%3A%20MET%20value,divide%20that%20number%20by%20four.
    //MET value multiplied by weight in kilograms tells you calories burned per hour (MET*weight in kg=calories/hour)
    
    @IBAction func startTimer(_ sender: Any) {
        startButton.isEnabled = false
        pauseButton.isEnabled = true
//        setrep.isHidden = true
        if(!started) {
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            trainer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(setrepAction), userInfo: nil, repeats: true)
            started = true
            }
        else
        {
            print("end timer")
            timer.invalidate()
            started = false
        }
            
    }
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func pauseTime(_ sender: Any) {
        
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        setrep.isHidden = false
        timer.invalidate()
        trainer.invalidate()
        startButton.setTitle("Resume Workout", for: .normal)
        started = false
    }
    @IBAction func resetTime(_ sender: Any) {
        timer.invalidate()
        trainer.invalidate()
        timerDisplay.text = defaultTimer()
        setrep.text = convertDefaultSet(set: set, rep: reps)
        calorieLabel.text = convertToCalorieDisplay(calorie: 0)
        startButton.setTitle("Start Workout", for: .normal)
        startButton.isEnabled = true
        started = false
        
    }
    
    @objc func timerAction(){
        if(milli == 9)
        {
            milli = 0
            secondspassed += 1
            caloriecount = Int(calperhour * (secondspassed / 60.0 / 60.0))
            if(second == 59)
            {
                
                second = 0
                if(minute == 59)
                {
                    hour += 1
                    minute = 0
                }
                else
                {
                    minute += 1
                }
            }
            else
            {
                second += 1
            }
            
        }
        else
        {
            milli += 1
        }
        timerDisplay.text = convertToTimerDisplay(hour: hour, minute: minute, second: second, milli: milli)
        calorieLabel.text = convertToCalorieDisplay(calorie: caloriecount)

    }
    
    @objc func setrepAction(){
        repsPassed -= 1
        if(reps == 1)
        {
            reps = 10
            if(set == 0)
            {
                timer.invalidate()
                trainer.invalidate()
                setrep.isHidden = true
            }
            else
            {
                set -= 1
            }
        }
        else
        {
            reps -= 1
        }
        setrep.text = convertDefaultSet(set: set, rep: reps)
    }
    
    
    @IBAction func timerButtonTapped(_ sender: UIButton)
    {
        if(!started)
        {
            print("started Time")
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            
            started = true
        }
        else
        {
            print("end timer")
            timer.invalidate()
            started = false
        }
        
    }
    

//    @IBOutlet weak var resetButton: UIButton!
//
//    @IBAction func resetTime(_ sender: Any) {
//
//        resetButton.isEnabled = false
//        timer.invalidate()
//        started = false
//    }
    
    func loadAccountInfo() {
            // Cite: https://github.com/nealight/Apply
            print("loading account info")
            
            let db = Firestore.firestore()
            let currentUser = Auth.auth().currentUser
            let currentUID = currentUser?.uid as! String
            let userRef = db.collection("users").document(currentUID)

            userRef.getDocument
            {
                (document, error) in
                if let document = document, document.exists
                {
                    let dataDescription = document.data()
    //                print("Document data: \(dataDescription)")
                    let weightstring = dataDescription?["weight"] as? String ?? ""
                    
                    self.weight = Int(weightstring) ?? 50
                }
                else
                {
                    print("Document does not exist")
                }
            }
            return
        }
    
    
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
