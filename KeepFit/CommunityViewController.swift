//
//  CommunityViewController.swift
//  KeepFit
//
//  Created by Albert on 2021/3/26.
//

import UIKit
import Foundation
import Firebase

class CommunityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // NOTE!!!: nickname and zoomlink are both required. They need to exist in the backend!

    var users = [UserSnapshot]()
    let db = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchUsers = [UserSnapshot]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
        // Do any additional setup after loading the view.
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
                            let profileImage = userObj?["profileImage"] as? String ?? ""
                            
                            let user = UserSnapshot(nickname: nickname as!String, zoomlink: zoomlink as! String, profileURL: profileImage)
                            self.users.append(user)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching
        {
            return searchUsers.count
        }
        else
        {
             return users.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! CommunityViewCell
//        guard let label = cell.textLabel else {
//            return cell
//        }
//        guard let subtitle = cell.detailTextLabel else {
//            return cell
//        }
        if searching
        {
            let user: UserSnapshot
            user = searchUsers[indexPath.row]
            cell.nicknameL.text = user.nickname
            cell.zoomlinkL.text = user.zoomlink
        }
        else
        {
            let user: UserSnapshot
            user = users[indexPath.row]
            cell.nicknameL.text = user.nickname
            cell.zoomlinkL.text = user.zoomlink
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching
        {
//            guard let videoURL = URL(string: searchVideos[indexPath.row].link!) else {
//                return
//            }
            
//            let player = AVPlayer(url: videoURL)
//            let controller = AVPlayerViewController()
//            controller.player = player
//
//            present(controller, animated: true) {
//                player.play()
//            }
        }
        else
        {
//            guard let videoURL = URL(string: videos[indexPath.row].link!) else {
//                return
//            }
            
//            let player = AVPlayer(url: videoURL)
//            let controller = AVPlayerViewController()
//            controller.player = player
//
//            present(controller, animated: true) {
//                player.play()
//            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchUsers.removeAll()
        for user:UserSnapshot in users
        {
            if let nickname = user.nickname
            {
                if nickname.lowercased().contains(searchText.lowercased())
                {
                    searchUsers.append(user)
                }
            }
        }
        searching = true
        tableView.reloadData()
        
//        searchVideos = videos.filter($0.title.prefix(searchText.count))
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
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
