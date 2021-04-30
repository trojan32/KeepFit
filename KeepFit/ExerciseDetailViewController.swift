//
//  ExerciseDetailViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/24/21.
//
import UIKit

class ExerciseDetailViewController: UIViewController {

    @IBOutlet var timerDisplay: UILabel!
    @IBOutlet var startStopButton: UIButton!
    var started = false;
    
    var timer = Timer()
    var hour = 0
    var minute = 0
    var second = 0
    
    var secondspassed = 0.0
//    var METvalue = 0?
    var calperhour = 0.0
    var caloriecount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerDisplay.text = convertToTimerDisplay(hour:0, minute: 0, second: 0)
        
        // calperhour = MET * weight

        // Do any additional setup after loading the view.
    }
    
    func convertToTimerDisplay(hour: Int, minute: Int, second: Int) -> String {
        return "\(hour):\(minute):\(second)"
    }
    
    
    //https://www.businessinsider.com/how-to-calculate-calories-burned-exercise-met-value-2017-8#:~:text=Here's%20your%20equation%3A%20MET%20value,divide%20that%20number%20by%20four.
    //MET value multiplied by weight in kilograms tells you calories burned per hour (MET*weight in kg=calories/hour)
    
    @IBAction func startTimer(_ sender: Any) {
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        if(!started) {
            
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
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBAction func pauseTime(_ sender: Any) {
        
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        timer.invalidate()
        started = false
    }
    
    @objc func timerAction(){
        secondspassed += 1.0
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
        timerDisplay.text = convertToTimerDisplay(hour: hour, minute: minute, second: second)
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
    
    
    
    
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
