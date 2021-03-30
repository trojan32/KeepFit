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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerDisplay.text = convertToTimerDisplay(hour:0, minute: 0, second: 0)

        // Do any additional setup after loading the view.

    }
    
    func convertToTimerDisplay(hour: Int, minute: Int, second: Int) -> String {
        return "\(hour):\(minute):\(second)"
    }
    
    
    @objc func timerAction(){
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
            print("start timer")
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
