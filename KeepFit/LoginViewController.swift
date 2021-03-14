//
//  LoginViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/14/21.
//

import UIKit

class LoginViewController: UIViewController, UINavigationControllerDelegate {
    
    let personalAccountModel = PersonalAccountModel.shared
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var accountTF: UITextField!
    @IBOutlet var passswordTF: UITextField!
    
    
    @IBAction func loginTapped(_ sender: UIBarButtonItem) {
        let loggedIn = personalAccountModel.logIntoAccount(account: accountTF.text ?? "", password: passswordTF.text ?? "")
        if loggedIn {
            dismiss(animated: true, completion: nil)
        } else {
            badLogin()
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
