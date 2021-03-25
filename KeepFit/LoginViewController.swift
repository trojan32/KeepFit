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
//        let loggedIn = personalAccountModel.logIntoAccount(account: accountTF.text ?? "", password: passswordTF.text ?? "")
//        if loggedIn {
//            dismiss(animated: true, completion: nil)
//        } else {
//            badLogin()
//        }
        
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
                    
//                    let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
//
//                    self.view.window?.rootViewController = homeViewController
//                    self.view.window?.makeKeyAndVisible()
//                    let currentUser = Auth.auth().currentUser
                    if let user = Auth.auth().currentUser{
                        let uid = user.uid
                        let email = user.email
                        print(email)
                    }
                    self.dismiss(animated: true, completion: nil)                    //  let currentUID = currentUser?.uid as! String
//                    users.child(currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
//                    // Get user snapshot (dictionary)
//                    let userSnapshot = snapshot.value as? NSDictionary
//                    // get nickname
//                    let nickname = userSnapshot?["nickname"] as? String ?? ""
//                    // set label to nickname
//                        print("Hello \(nickname)")
//                    }) { (error) in print(error.localizedDescription)
//                      // set full name to empty string
//                    }
                }
            }
        }
    }
    
    func badLogin() {
        // Implement badLogin below
        
        // Implement badLogin above
        return
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
