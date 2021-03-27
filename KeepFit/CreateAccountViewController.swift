//
//  CreateAccountViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/12/21.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateAccountViewController:  UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var profileImage: String?
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var error: UILabel!
    
    
    //    let personalAccountModel = PersonalAccountModel.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        // Hide the error label
        error.alpha = 0
        // Style the elements
        Utilities.styleTextField(password)
        Utilities.styleTextField(email)
        Utilities.styleTextField(nickname)
        Utilities.styleTextField(birthday)
        Utilities.styleTextField(height)
        Utilities.styleTextField(weight)
    }
    
    @IBAction func addImagePressed(_ sender: UIButton) {
        // Cite: My ITP iOS dev class project code and  https://www.hackingwithswift.com/read/10/4/importing-photos-with-uiimagepickercontroller
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Cite: https://www.hackingwithswift.com/read/10/4/importing-photos-with-uiimagepickercontroller
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        let imageName = UUID().uuidString
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
               
               
        let imagePath = url!.appendingPathComponent(imageName)
        
        if let jpedData = image.jpegData(compressionQuality: 0.99) {
            try? jpedData.write(to: imagePath)
            
        }
        
        profileImage = imageName
        
        dismiss(animated: true)
    }
    
    func validateFields() -> String? {

        // Check that all fields are filled in
        if password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || nickname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            birthday.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || height.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || weight.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        guard let heighttest = Int(height.text!) else {
            return "Please fill in a number for height."
        }
        
        guard let weighttest = Int(weight.text!) else {
            return "Please fill in a number for weight."
        }
        
        return nil
    }
    
    @IBAction func createAccountTapped(_ sender: UIBarButtonItem)
    {

    
//        dismiss(animated: true, completion: nil)

        // Validate the fields
        let error = validateFields()
        
        if error != nil
        {
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else
        {
            // Create cleaned versions of the data
            let password_txt = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email_txt = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let nickname_txt = nickname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let birthday_txt = birthday.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let height_txt = height.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let weight_txt = weight.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email_txt, password: password_txt) { (result, err) in
                // Check for errors
                if err != nil
                {
                    // There was an error creating the user
                    self.showError("Error creating user")
                }
                else
                {
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData([
                        "email":email_txt,
                        "nickname":nickname_txt,
                        "birthday":birthday_txt,
                        "height":height_txt,
                        "weight":weight_txt,
                        "uid": result!.user.uid,
                        "zoomlink": ""
                    ]) { (error) in
                        
                        if error != nil
                        {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    // Transition to the home screen
//                    self.transitionToHome()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func showError(_ message:String) {
        
        error.text = message
        error.alpha = 1
    }
    
//    func transitionToHome() {
//
//        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
//
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
//
//    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
