//
//  MyUploadedVideosViewController.swift
//  KeepFit
//
//  Created by Albert on 2021/5/9.
//

import UIKit
import Foundation
import Firebase
import AVKit

class MyUploadedVideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var videos = [Video]()
    let db = Firestore.firestore()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchVideos = [Video]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideos()
        // Do any additional setup after loading the view.
    }
    
    func loadVideos()
    {
        let user = Auth.auth().currentUser
        if let user = user {
            let currentUID = user.uid as! String
            let userRef = db.collection("users").document(currentUID)
            let uploadedVideosRef = userRef.collection("UploadedVideos")
            uploadedVideosRef.getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let actualquery = querySnapshot
                    {
                        if !actualquery.isEmpty
                        {
                            self.videos.removeAll()
                            for document in querySnapshot!.documents {
                                let videoObj = document.data() as? [String: AnyObject]
                                let title = videoObj?["title"]
                                let link = videoObj?["link"]
                                let id = videoObj?["id"]
                                let video = Video(title: title as! String, link: link as! String, id: id as! String)
                                self.videos.append(video)
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            let db = Firestore.firestore()
            db.collection("videos").document(self.videos[indexPath.row].id!).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            
            let user = Auth.auth().currentUser
            if let user = user {
                let currentUID = user.uid as! String
                let userRef = db.collection("users").document(currentUID)
                let uploadedVideosRef = userRef.collection("UploadedVideos")
                uploadedVideosRef.document(self.videos[indexPath.row].id!).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            }
            
            if self.searching
            {
                self.searchVideos.remove(at: indexPath.row)
            }
            else
            {
                self.videos.remove(at: indexPath.row)
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

            completion(true)
        }
        action.image = #imageLiteral(resourceName: "Trash")
        action.backgroundColor = .red
        
        return action
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching
        {
            return searchVideos.count
        }
        else
        {
             return videos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! VideoTableViewCell
        if searching
        {
            let video: Video
            video = searchVideos[indexPath.row]
            cell.titleLabel.text = video.title
        }
        else
        {
            let video: Video
            video = videos[indexPath.row]
            cell.titleLabel.text = video.title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching
        {
            guard let videoURL = URL(string: searchVideos[indexPath.row].link!) else {
                return
            }
            
            let player = AVPlayer(url: videoURL)
            let controller = AVPlayerViewController()
            controller.player = player
            
            present(controller, animated: true) {
                player.play()
            }
        }
        else
        {
            guard let videoURL = URL(string: videos[indexPath.row].link!) else {
                return
            }
            
            let player = AVPlayer(url: videoURL)
            let controller = AVPlayerViewController()
            controller.player = player
            
            present(controller, animated: true) {
                player.play()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchVideos.removeAll()
        for video:Video in videos
        {
            if let t = video.title
            {
                if t.lowercased().contains(searchText.lowercased())
                {
                    searchVideos.append(video)
                }
            }
        }
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
