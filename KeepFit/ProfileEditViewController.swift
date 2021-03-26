//
//  ProfileEditViewController.swift
//  KeepFit
//
//  Created by Albert on 2021/3/25.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileEditViewController: UIViewController {

    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var error: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideError()
        loadAccountInfo()
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
                let nickname_txt = dataDescription?["nickname"] as? String ?? ""
                let birthday_txt = dataDescription?["birthday"] as? String ?? ""
                let height_txt = dataDescription?["height"] as? String ?? ""
                let weight_txt = dataDescription?["weight"] as? String ?? ""
                
                self.nickname.text = nickname_txt
                self.birthday.text = birthday_txt
                self.height.text = height_txt
                self.weight.text = weight_txt
            }
            else
            {
                print("Document does not exist")
            }
        }
        return
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        let password_txt = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let nickname_txt = nickname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let birthday_txt = birthday.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let height_txt = height.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let weight_txt = weight.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if validatePassword() == false {
            let err = "Update failed. Please make sure your password is at least 8 characters, contains a special character and a number."
            showError(err)
            
        }
        else {
            if let err = validateFields() {
                showError(err)
            }
            else {
                let db = Firestore.firestore()
                let currentUser = Auth.auth().currentUser
                let currentUID = currentUser?.uid as! String
                let userRef = db.collection("users").document(currentUID)
                
                userRef.updateData([
                    "nickname": nickname_txt,
                    "birthday": birthday_txt,
                    "height": height_txt,
                    "weight": weight_txt
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                if password_txt != "" {
                    Auth.auth().currentUser?.updatePassword(to: password_txt) { (error) in
                        
                    }
                }
                self.showError("Update Success")
            }
        }
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if nickname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            birthday.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || height.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || weight.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields except password."
        }
        return nil
    }
    
    func validatePassword() -> Bool? {
        // Check that all fields are filled in
        if password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return true
        }
        
        // Check if the password is secure
        let cleanedPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        return Utilities.isPasswordValid(cleanedPassword)
    }
    
    func showError(_ message:String) {
        error.text = message
        error.alpha = 1
    }
    
    func hideError() {
        error.text = "Error"
        error.alpha = 0
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
