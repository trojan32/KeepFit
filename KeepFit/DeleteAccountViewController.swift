//
//  DeleteAccountViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 4/13/21.
//

import UIKit
import Firebase

class DeleteAccountViewController: UIViewController {

    @IBOutlet var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        var credential : AuthCredential


        credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: passwordTF.text ?? "")

        user?.reauthenticate(with: credential) { error,arg  in
            if error != nil {
            // An error happened.""
                print(error ?? "Error occurred")
                return

            } else {
            // User re-authenticated.
            }
        }


        // delete the user data in database
        db.collection("users").document(user?.uid ?? "").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }

        // delete the user from authentication system
        user?.delete { error in
          if let error = error {
            // An error happened.
            print(error)
          } else {
            // Account deleted.
          }
        }

        
        
//        self.dismiss(animated: true, completion: nil)
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
