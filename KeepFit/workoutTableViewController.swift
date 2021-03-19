//
//  workoutTableViewController.swift
//  KeepFit
//
//  Created by kevin on 3/19/21.
//

import UIKit

class workoutTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    
    let workoutItems = ["Yoga","Swimming","Running","Cycling","HITT","Zumba","Crossfit","'orange theory'","lifting","ping pong","stretching"]
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutItems.count
    }
    
//    @IBOutlet weak var workoiut: UITableViewCell!
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath)

        cell.textLabel?.text = workoutItems[indexPath.row]
//        let imageName = UIImage(named: transportItems[indexPath.row])
//        cell.imageView?.image = imageName

        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
   
}
