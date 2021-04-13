//
//  UserStreamingViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/20/21.
//

import UIKit
import Firebase


class UserStreamingViewController: UIViewController {
    
    
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var nickNameTF: UILabel!
    @IBOutlet var linkTF: UILabel!
    
    @IBOutlet var streamingStatusTF: UILabel!
    
    var imageURL: String = ""
    var streamStarted = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedProfile = StreamPageTableViewController.selectedUser else {
            return
        }

        nickNameTF.text = selectedProfile.nickname
        linkTF.text = selectedProfile.zoomlink
        imageURL = selectedProfile.profileURL ?? ""
        
        loadProfileImage()
        loadExistingInfo()
        

        // Do any additional setup after loading the view.
    }
    
    func loadProfileImage() {
        
        
        if imageURL != "" {
            
            
            
            let imagePath = URL(string: imageURL)!
            
            print(imagePath)
            do {
                profilePhoto.image = UIImage(data: try Data(contentsOf: imagePath))
            } catch {}
        }
    }
    
    func loadExistingInfo() {
        let serialQueue = DispatchQueue(label: "com.test.mySerialQueue")
        
        // code
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        let currentUID = currentUser?.uid as! String
        let userRef = db.collection("users").document(currentUID)
        
        userRef.getDocument
        {
            (document, error) in
            if let document = document, document.exists
            {
                let dataDescription = document.data()
//                print("Document data: \(dataDescription)")
                let status = dataDescription?["stream_started"] as? String ?? ""
                
                if (status == "true") {
                    self.streamingStatusTF.text = "User has started streaming. Click on the link below to join."
                } else {
                    self.streamingStatusTF.text = "User has not started streaming yet."
                }
                
            }
            else
            {
                print("Document does not exist")
            }
        }
        
        
        
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
