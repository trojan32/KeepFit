//
//  ProfilePageViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/13/21.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    let personalAccountModel = PersonalAccountModel.shared

    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !personalAccountModel.loggedIn {
            performSegue(withIdentifier: "loginSegue", sender: self)
        } else {
            print("user logged in")
            loadAccountInfo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadAccountInfo() {
        
        // Cite: https://github.com/nealight/Apply
        
        print("loading account info")
        
        loadProfileImage()
        nicknameLabel.text = personalAccountModel.personalAccount.nickname
        birthdayLabel.text = "Birthday: \( personalAccountModel.personalAccount.birthday)"
        heightLabel.text = "Height: \(personalAccountModel.personalAccount.height) cm"
        weightLabel.text = "Weight: \(personalAccountModel.personalAccount.weight) kg"
        

        
        
        return
    }
    
    func loadProfileImage() {
        let imageName = personalAccountModel.personalAccount.profilePhotoURL
        
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
    
    
    @IBAction func logOut(_ sender: UIButton) {
        let _ = personalAccountModel.logOutOfAccount()
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
