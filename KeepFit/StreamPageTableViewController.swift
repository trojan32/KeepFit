//
//  StreamPageTableViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/15/21.
//

import UIKit

class StreamPageTableViewController: UITableViewController, UISearchResultsUpdating {
    
    static public var selectedProfile: UserProfile? = nil
    let userProfileModel = UserProfileModel.shared
    
    private var typed_text: String = ""
    private var searchedUserProfiles: Array<UserProfile> = UserProfileModel.shared.searchForZoomRooms(search_text: "")
    
    override func viewDidAppear(_ animated: Bool) {
        userProfileModel.render()
        updateView(text: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cite: https://www.hackingwithswift.com/example-code/uikit/how-to-use-uisearchcontroller-to-let-users-enter-search-words
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
        
    

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchedUserProfiles.count
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        updateView(text: text)

    }
    
    func updateView(text: String) {
        searchedUserProfiles = userProfileModel.searchForZoomRooms(search_text: text)
        
        tableView.reloadData()
        
        print("User entered \(text)")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "streamRoom", for: indexPath)
        
        guard let label = cell.textLabel else {
            return cell
        }
        
        guard let subtitle = cell.detailTextLabel else {
            return cell
        }
        
        // Configure the cell...
        let nickname = searchedUserProfiles[indexPath.row].nickname
        let zoomLink = searchedUserProfiles[indexPath.row].zoomLink

        label.text = nickname
        subtitle.text = zoomLink
        
        print("Updating rows")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row.
        tableView.deselectRow(at: indexPath, animated: false)
        
        
        StreamPageTableViewController.selectedProfile = searchedUserProfiles[indexPath.row]
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
