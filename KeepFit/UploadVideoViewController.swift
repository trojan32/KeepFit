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
import CoreMedia
import Firebase


class UploadVideoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideError()
    }

    @IBOutlet weak var videoTitle: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
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
        
        // 28. (3). The user cannot upload extremely large video files. You should set a restriction on the file size and video length.
        // file size should be less than 10M = 10240K = 10485760b
        // video length should be less than 1min = 60s
        let asset = AVURLAsset(url: videoURL as URL)
        let videoSize = asset.fileSize
        let durationInSeconds = asset.duration.seconds
        print(videoSize ?? 0)
        print(durationInSeconds)
        
        let error = validateFields(size: videoSize ?? 0, time: durationInSeconds)
        if error != nil
        {
            showError(error!)
            return
        }
        
        // No Error
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
        
        showSuccessMessage()
    }
    
    func validateFields(size: Int, time: Double) -> String? {
        // Check that all fields are filled in
        if size >= 10485760
        {
            return "Error: file size should be less than 10M (after compression)"
        }
        if time >= 60
        {
            return "Error: video length should be less than 1min"
        }
        return nil
    }

    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func hideError() {
        errorLabel.alpha = 0
    }
    
    func showSuccessMessage(){
        errorLabel.text = "The video is uploaded successfully!"
        errorLabel.alpha = 1
        errorLabel.textColor = .green
    }
}

extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)

        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}
