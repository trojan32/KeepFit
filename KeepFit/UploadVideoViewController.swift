//
//  UploadVideoViewController.swift
//  KeepFit
//
//  Created by Albert on 2021/4/30.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import Firebase


class UploadVideoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var videoTitle: UITextField!
    
    var picker = UIImagePickerController()
    var videoURL : NSURL?
    
    @IBAction func PickAVideo(_ sender: Any) {
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL{
            print("Here is the file URL: \(videoUrl)")
            videoURL = videoUrl.filePathURL as? NSURL // this is the only thing I changed cause this is the file we are uploading
//            videoURL = videoUrl
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func PlayThePickedVideo(_ sender: Any) {
        if let videoURL = videoURL{
            let player = AVPlayer(url: videoURL as URL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
            playerViewController.player!.play()
          }
        }
    }
    
    @IBAction func UploadTheVideo(_ sender: Any) {
        guard let videoURL = videoURL else { return }
        
        let randomID = UUID.init().uuidString
        let storageRef = Storage.storage().reference(withPath: "Videos/\(randomID).mp4")
        
        storageRef.putFile(from: videoURL as URL, metadata: nil) { (metaData, error) in
             // IMPORTANT: this is where I got the error from
            if error != nil {
                print("error uploading video: \(error!.localizedDescription)")
            } else {
                print("!!!")
                // successfully uploaded the video
                storageRef.downloadURL { (url, error) in
                    if error != nil {
                        print("error downloading uploaded videos Url: \(error!.localizedDescription)")
                    } else {
                        if let downloadUrl = url {
                            let db = Firestore.firestore()
                            let videosRef = db.collection("videos")
                            let newVideoRef = videosRef.document()
                            let newVideo = [
                                "link" : downloadUrl.absoluteString,
                                "title": self.videoTitle.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                "id" : newVideoRef.documentID
                            ]
                            newVideoRef.setData(newVideo)

                            let user = Auth.auth().currentUser
                            if let user = user {
                                let currentUID = user.uid as! String
                                let userRef = db.collection("users").document(currentUID)
                                let uploadedVideosRef = userRef.collection("UploadedVideos")
                                uploadedVideosRef.document(newVideoRef.documentID).setData(newVideo)
                            }
                        }
                    }
                }
            }
        }
    }

}
