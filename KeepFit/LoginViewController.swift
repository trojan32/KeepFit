//
//  LoginViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/14/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UINavigationControllerDelegate {
    
    let personalAccountModel = PersonalAccountModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var error: UILabel!

    func setUpElements() {
        // Hide the error label
        error.alpha = 0
        // Style the elements
        Utilities.styleTextField(email)
        Utilities.styleTextField(password)
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        return nil
    }
    
    func showError(_ message:String) {
        error.text = message
        error.alpha = 1
    }
    
    @IBAction func loginTapped(_ sender: UIBarButtonItem) {
        // TODO: Validate Text Fields
        let error = validateFields()
        
        if error != nil
        {
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else{
            // Create cleaned versions of the text field
            let email_txt = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password_txt = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // Signing in the user
            Auth.auth().signIn(withEmail: email_txt, password: password_txt) { (result, err) in
                if err != nil {
                    // Couldn't sign in
                    self.error.text = err!.localizedDescription
                    self.error.alpha = 1
                }
                else {
                    if let user = Auth.auth().currentUser{
                        let uid = user.uid
                        let email = user.email
                        print(email)
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func retrievePasswordTapped(_ sender: Any) {
        
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let err = "Please fill the email that you want to retrieve."
        }
        if err != nil
        {
            showError(err!)
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            showError(error!.localizedDescription)
        }
    }
    

}
