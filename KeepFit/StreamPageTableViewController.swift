//
//  StreamPageTableViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/15/21.
//

import UIKit
import FirebaseAuth
import Firebase

class StreamPageTableViewController: UITableViewController, UISearchResultsUpdating {
    
    static public var selectedProfile: UserProfile? = nil
//    let userProfileModel = UserProfileModel.shared
    private var typed_text: String = ""
//    private var searchedUserSnapshot: Array<UserSnapshot> = Array<UserSnapshot>()
//    var searchedUserSnapshot = [UserSnapshot]()
//    static let userRef = db.collection("users")
    
    let db = Firestore.firestore()
    var users = [UserSnapshot]()
    var searchUsers = [UserSnapshot]()
    var searching = false
    
    override func viewDidAppear(_ animated: Bool) {
//        userProfileModel.render()
//        updateView(text: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
        
        // Cite: https://www.hackingwithswift.com/example-code/uikit/how-to-use-uisearchcontroller-to-let-users-enter-search-words
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
//        search.searchBar.delegate = self;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching
        {
            return searchUsers.count
        }
        else
        {
            return users.count
        }
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive
        {
            print("Cancelled")
            searching = false
            self.tableView.reloadData()
        }
        
        guard let text = searchController.searchBar.text else { return }
        updateView(text: text)
    }
    
    func updateView(text: String) {
        searchUsers.removeAll()
        for user:UserSnapshot in users
        {
            if let nickname = user.nickname
            {
                if nickname.lowercased().contains(text.lowercased())
                {
                    searchUsers.append(user)
                }
            }
        }
        searching = true
        self.tableView.reloadData()
//        let query = StreamPageTableViewController.userRef.whereField("nickname", isEqualTo: text)
//
//        self.searchedUserSnapshot.removeAll()
//
//        query.getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        let dataDescription = document.data()
//        //                print("Document data: \(dataDescription)")
//
//                        self.searchedUserSnapshot.append(UserSnapshot(nickname: dataDescription["nickname"] as? String ?? "", zoomlink: dataDescription["nickname"] as? String ?? ""))
//                    }
//                    self.tableView.reloadData()
//                }
//        }
        print("User entered \(text)")
    }
    
    func loadUsers()
    {
        let usersRef = db.collection("users")
        usersRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let actualquery = querySnapshot
                {
                    if !actualquery.isEmpty
                    {
                        self.users.removeAll()
                        for document in querySnapshot!.documents {
                            let userObj = document.data() as? [String: AnyObject]
                            let nickname = userObj?["nickname"]
                            let zoomlink = userObj?["zoomlink"]
                            let user = UserSnapshot(nickname: nickname as!String, zoomlink: zoomlink as! String)
                            self.users.append(user)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "streamRoom", for: indexPath)
        guard let label = cell.textLabel else {
            return cell
        }
        guard let subtitle = cell.detailTextLabel else {
            return cell
        }
        if searching
        {
            let user: UserSnapshot
            user = searchUsers[indexPath.row]
            label.text = user.nickname
            subtitle.text = user.zoomlink
        }
        else
        {
            let user: UserSnapshot
            user = users[indexPath.row]
            label.text = user.nickname
            subtitle.text = user.zoomlink
        }
        
//        // Configure the cell...
//        let nickname = searchedUserSnapshot[indexPath.row].nickname
//        let zoomLink = searchedUserSnapshot[indexPath.row].zoomlink
//
//        label.text = nickname
//        subtitle.text = zoomLink
        
        print("Updating rows")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row.
        tableView.deselectRow(at: indexPath, animated: false)
//        StreamPageTableViewController.selectedProfile = searchedUserSnapshot[indexPath.row]
    }
}
