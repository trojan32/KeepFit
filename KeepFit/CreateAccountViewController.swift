//
//  CreateAccountViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/12/21.
//

import UIKit

class CreateAccountViewController:  UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var profileImage: String?
    
    @IBOutlet var accountTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var nicknameTF: UITextField!
    @IBOutlet var birthdayTF: UITextField!
    @IBOutlet var heightTF: UITextField!
    @IBOutlet var weightTF: UITextField!
    
    let personalAccountModel = PersonalAccountModel.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func createAccountTapped(_ sender: UIBarButtonItem) {
        personalAccountModel.createNewAccount(account: accountTF.text ?? "", password: passwordTF.text ?? "", nickname: nicknameTF.text ?? "", birthday: birthdayTF.text ?? "", height: heightTF.text ?? "", weight: weightTF.text ?? "", profilePhotoURL: profileImage ?? "")
        
        dismiss(animated: true, completion: nil)
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
