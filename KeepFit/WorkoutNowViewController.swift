//
//  WorkoutNowViewController.swift
//  KeepFit
//
//  Created by kevin on 3/14/21.
//
 
import UIKit

class WorkoutNowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var workoutTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        

        self.workoutTableView.delegate = self
        self.workoutTableView.dataSource = self
    }
    
    let workoutItems = ["Yoga","Swimming","Running","Cycling","HITT","Zumba","Crossfit","Orange Theory","Lifting","Ping Pong","Stretching", "Sit Up"]

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutItems.count
    }
    
//    @IBOutlet weak var workoiut: UITableViewCell!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath)

        cell.textLabel?.text = workoutItems[indexPath.row]
        let imageName = UIImage(named: workoutItems[indexPath.row])
        cell.imageView?.image = imageName
//        cell.imageView = cell.imageView?.image?.resizableImage(withCapInsets: 1x1)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        return cell
    }
  
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
////
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//            // cell selected code here
//        }
    
    


  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
