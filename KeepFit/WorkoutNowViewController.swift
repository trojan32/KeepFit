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
        self.workoutTableView.delegate = self
        self.workoutTableView.dataSource = self
    }
    
    let workoutItems = ["Yoga","Swimming","Running","Cycling","HITT","Zumba","Crossfit","Orange Theory'","Lifting","Ping Pong","Stretching"]

    
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
//        let imageName = UIImage(named: transportItems[indexPath.row])
//        cell.imageView?.image = imageName

        return cell
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
