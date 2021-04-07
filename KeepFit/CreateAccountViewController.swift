//
//  CreateAccountViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/12/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class CreateAccountViewController:  UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    static public var profileImage: String? = "Default"
    
    @IBOutlet weak var create: UIBarButtonItem!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
        weight.accessibilityIdentifier = "profileCWeightTF"
        height.accessibilityIdentifier = "profileCHeightTF"
        birthday.accessibilityIdentifier = "profileCBirthdayTF"
        nickname.accessibilityIdentifier = "profileCNicknameTF"
        email.accessibilityIdentifier = "profileCEmailTF"
        password.accessibilityIdentifier = "profileCPasswordTF"
        headlineLabel.accessibilityIdentifier = "profileCHeadlineLabel"
        create.accessibilityIdentifier = "profileCCreateButton"
        error.accessibilityIdentifier = "profileCErrorLabel"
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        tapToChangeProfileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc func openImagePicker(_ sender: Any)
    {
        self.present(imagePicker, animated: true, completion: nil)
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
            guard let image = profileImageView.image else { return }
            
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
                    // User was created successfully, now store the info
                    print("User Created!")
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
                    
                    // Upload the profile image to Firebase Storage
                    self.uploadProfileImage(image) { url in
                        if url != nil {
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.photoURL = url
                            changeRequest?.commitChanges(completion: { (error) in
                                if error == nil {
                                    print("User photoURL changed!")
                                    db.collection("users").document(result!.user.uid).updateData([
                                        "profileImage":url!.absoluteString
                                    ]) { (error) in
                                        if error != nil
                                        {
                                            // Show error message
                                            self.showError("Error saving user data")
                                        }
                                    }
                                } else {
                                    print("ERROR: \(error!.localizedDescription)")
                                }
                            })
                        } else {
                            print("Unable to upload profile image.")
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func showError(_ message:String) {
        
        error.text = message
        error.alpha = 1
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->()))
    {
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "UserProfileImages/\(randomID).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else{ return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetadata) { downloadMetadata, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                completion(nil)
            }
            guard let downloadMetadata = downloadMetadata else {
              // Uh-oh, an error occurred!
              return
            }
            print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
            uploadRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  // Uh-oh, an error occurred!
                  return
                }
                completion(downloadURL)
            }
        }
    }
}

extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
