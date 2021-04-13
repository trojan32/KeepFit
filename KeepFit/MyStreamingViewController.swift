//
//  MyStreamingViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/20/21.
//

import UIKit
import FirebaseAuth
import Firebase

class MyStreamingViewController: UIViewController {
    
    let profileModel = UserProfileModel.shared
    let personalAccountModel = PersonalAccountModel.shared
    
    @IBOutlet var startStopButton: UIBarButtonItem!
    var streamStarted = false;
    
    let db = Firestore.firestore()
    
    
    
    @IBOutlet var zoomLinkTF: UITextField!
    
    func loadExistingInfo() {
        let serialQueue = DispatchQueue(label: "com.test.mySerialQueue")
        
        // code
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
                    self.streamStarted = true
                } else {
                    self.streamStarted = false
                }
                
            }
            else
            {
                print("Document does not exist")
            }
        }
        
        updateStartStopButton()
        
    }
    
    func updateStartStopButton() {
        if streamStarted {
            startStopButton.title = "Stop"
        } else {
            startStopButton.title = "Start"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        zoomLinkTF.text = personalAccountModel.myAccountProfile?.zoomLink
        
        loadExistingInfo()
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func zoomLinkModified(_ sender: UITextField) {
        personalAccountModel.EditZoomLink(link: sender.text ?? "")
        let currentUser = Auth.auth().currentUser
        let currentUID = currentUser?.uid as! String
        let userRef = db.collection("users").document(currentUID)
        
        
        userRef.updateData([
            "zoomlink": zoomLinkTF.text,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }

        
    }
    

    @IBAction func startStopPressed(_ sender: UIBarButtonItem) {
        let serialQueue = DispatchQueue(label: "com.test.mySerialQueue")
        serialQueue.sync {
            let currentUser = Auth.auth().currentUser
            let currentUID = currentUser?.uid as! String
            let userRef = db.collection("users").document(currentUID)
            
            let status: String
            if (streamStarted) {
                status = "false"
                streamStarted = false
            } else {
                status = "true"
                streamStarted = true
            }
            
            userRef.updateData([
                "stream_started": status,
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
            loadExistingInfo()
            
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
