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

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
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
//        if !personalAccountModel.loggedIn {
//            performSegue(withIdentifier: "loginSegue", sender: self)
//        } else {
//            print("user logged in")
//            loadAccountInfo()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadAccountInfo() {
        // Cite: https://github.com/nealight/Apply
        print("loading account info")
        
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        let currentUID = currentUser?.uid as! String
        let usersRef = db.collection("users")
        usersRef.child(currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
        let userSnapshot = snapshot.value as? NSDictionary
        let nickname = userSnapshot?["nickname"] as? String ?? ""
        let birthday = userSnapshot?["birthday"] as? String ?? ""
        let height = userSnapshot?["height"] as? String ?? ""
        let weight = userSnapshot?["weight"] as? String ?? ""
        }) { (error) in print(error.localizedDescription) }
        
        loadProfileImage()
        nicknameLabel.text = nickname
        birthdayLabel.text = "Birthday: \(birthday)"
        heightLabel.text = "Height: \(height) cm"
        weightLabel.text = "Weight: \(weight) kg"
        return
    }
    
    func loadProfileImage() {
        let imageName = personalAccountModel.personalAccount.profilePhotoURL
        
        if imageName != "Default" {
            let manager = FileManager.default
            let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
            let imagePath = url!.appendingPathComponent(imageName)
            print(imagePath)
            do {
                profileImage.image = UIImage(data: try Data(contentsOf: imagePath))
            } catch {}
        }
    }
    
    
    @IBAction func logOut(_ sender: UIButton)
    {
//        let _ = personalAccountModel.logOutOfAccount()
      do{
        try Auth.auth().signOut()
      } catch let error {
        print(error)
      }
    }
}
