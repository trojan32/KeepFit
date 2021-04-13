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
        
        logInButton.accessibilityIdentifier = "profileSigninButton"
        
        email.accessibilityIdentifier = "profileEmailTF"
        password.accessibilityIdentifier = "profilePasswordTF"
        cancelButton.accessibilityIdentifier = "profileCancelButton"
        createAccount.accessibilityIdentifier = "profileCreateAccountButton"
    }
    
    @IBOutlet var logInButton: UIBarButtonItem!
    
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var error: UILabel!

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
        var err: String? = nil
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            err = "Please fill the email that you want to retrieve."
        }
        if err != nil
        {
            showError(err!)
        }
        let email_txt = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().sendPasswordReset(withEmail: email_txt) { error in
            self.showError(error?.localizedDescription ?? "check your mail box")
        }
    }
    

    

}
