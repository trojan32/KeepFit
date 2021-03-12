//
//  CreateAccountViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/12/21.
//

import UIKit

class CreateAccountViewController:  UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var profileImage: String?

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
