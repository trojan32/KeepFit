//
//  ProfilePageViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/13/21.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfilePageViewController: UIViewController {
    
    let personalAccountModel = PersonalAccountModel.shared
    
    let db = Firestore.firestore()

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var changeAccountInfo: UIButton!
    var imageURL: String = ""
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil {
          // User is signed in.
            print("user logged in")
            loadAccountInfo()
        } else {
          // No user is signed in.
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.accessibilityIdentifier = "profileLogoutButton"
        changeAccountInfo.accessibilityIdentifier = "profileChangeAccountInfoButton"
        
        nicknameLabel.accessibilityIdentifier = "profileNicknameLabel"
        birthdayLabel.accessibilityIdentifier = "profileBirthdayLabel"
        heightLabel.accessibilityIdentifier = "profileHeightLabel"
        weightLabel.accessibilityIdentifier = "profileWeightLabel"
        
        
    }
    
    func loadAccountInfo() {
        // Cite: https://github.com/nealight/Apply
        print("loading account info")
        
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
                let nickname = dataDescription?["nickname"] as? String ?? ""
                let birthday = dataDescription?["birthday"] as? String ?? ""
                let height = dataDescription?["height"] as? String ?? ""
                let weight = dataDescription?["weight"] as? String ?? ""
                
                let profileImage = dataDescription?["profileImage"] as? String ?? ""
                
                self.nicknameLabel.text = nickname
                self.birthdayLabel.text = "Birthday: \(birthday)"
                self.heightLabel.text = "Height: \(height) cm"
                self.weightLabel.text = "Weight: \(weight) kg"
                self.imageURL = profileImage
                
                self.loadProfileImage()
            }
            else
            {
                print("Document does not exist")
            }
        }
        return
    }
    
    func loadProfileImage() {
        
        
        if imageURL != "" {
            
            
            
            
            let imagePath = URL(string: imageURL)!
            
            print(imagePath)
            do {
                profileImage.image = UIImage(data: try Data(contentsOf: imagePath))
            } catch {}
        }
    }
    
    
    @IBAction func logOut(_ sender: UIButton)
    {
      do{
        try Auth.auth().signOut()
      } catch let error {
        print(error)
      }
    }
    
    
    @IBAction func deleteAccountTapped(_ sender: Any) {

       
        let user = Auth.auth().currentUser
        
        // delete the user data in database
        db.collection("users").document(user?.uid ?? "").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        // delete the user from authentication system
//        user?.delete { error in
//          if let error = error {
//            // An error happened.
//            print(error)
//
//            let user = Auth.auth().currentUser
//            var credential : AuthCredential
//            user?.reauthenticate(with: credential) { error,arg  in
//                if error != nil {
//                // An error happened.
//              } else {
//                // User re-authenticated.
//              }
//            }
//
//          } else {
//            // Account deleted.
//          }
//        }
        
        // switch to login page
        self.dismiss(animated: true, completion: nil)
        
        
    }
}
