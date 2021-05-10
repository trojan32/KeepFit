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
        let videosRef = db.collection("videos")
        videosRef.getDocuments { (querySnapshot, err) in
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
                            let video = Video(title: title as!String, link: link as! String)
                            self.videos.append(video)
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
