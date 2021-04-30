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
//        print("1")
        if let videoURL = videoURL{
//            print("2")
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
        
//        let videoData = NSData(contentsOf: videoURL as URL)
//        storageRef.putData(videoData! as Data)
        
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
                            db.collection("videos").addDocument(data: [
                                "link" : downloadUrl.absoluteString,
                                "title": self.videoTitle.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            ]) { (error) in
                                if error != nil
                                {
                                    print(error!.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        //        let metadata = StorageMetadata()
        //        metadata.contentType = "video/quicktime"
        //        print("Ready1")
        //        if let videoData = NSData(contentsOf: videoURL as URL) as Data? {
        //            print("Ready2")
        //            storageRef.putData(videoData, metadata: metadata) { (metaData, error) in
        //                 // IMPORTANT: this is where I got the error from
        //                if error != nil {
        //                    print("error uploading video: \(error!.localizedDescription)")
        //                } else {
        //                    print("!!!")
        //                    // successfully uploaded the video
        //                    storageRef.downloadURL { (url, error) in
        //                        if error != nil {
        //                            print("error downloading uploaded videos Url: \(error!.localizedDescription)")
        //                        } else {
        //                            if let downloadUrl = url {
        //                                let db = Firestore.firestore()
        //                                db.collection("videos").addDocument(data: [
        //                                    "link" : downloadUrl,
        //                                    "title": self.videoTitle.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //                                ]) { (error) in
        //                                    if error != nil
        //                                    {
        //                                        print(error!.localizedDescription)
        //                                    }
        //                                }
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //        }
    
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
