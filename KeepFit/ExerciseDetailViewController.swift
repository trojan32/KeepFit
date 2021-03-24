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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerDisplay.text = convertToTimerDisplay(minute: 0, second: 0)

        // Do any additional setup after loading the view.
    }
    
    func convertToTimerDisplay(minute: Int, second: Int) -> String {
        return "\(minute):\(second)"
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
