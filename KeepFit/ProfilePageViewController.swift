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
                self.loadProfileImage()
                self.nicknameLabel.text = nickname
                self.birthdayLabel.text = "Birthday: \(birthday)"
                self.heightLabel.text = "Height: \(height) cm"
                self.weightLabel.text = "Weight: \(weight) kg"
            }
            else
            {
                print("Document does not exist")
            }
        }
        return
    }
    
    func loadProfileImage() {
        let imageName = CreateAccountViewController.profileImage!
        
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
      do{
        try Auth.auth().signOut()
      } catch let error {
        print(error)
      }
    }
}
