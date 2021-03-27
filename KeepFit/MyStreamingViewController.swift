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
    
    
    let db = Firestore.firestore()
    
    
    
    @IBOutlet var zoomLinkTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        zoomLinkTF.text = personalAccountModel.myAccountProfile?.zoomLink
        

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
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
