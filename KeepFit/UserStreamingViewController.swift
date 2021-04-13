//
//  UserStreamingViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/20/21.
//

import UIKit

class UserStreamingViewController: UIViewController {
    
    
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var nickNameTF: UILabel!
    @IBOutlet var linkTF: UILabel!
    var imageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedProfile = StreamPageTableViewController.selectedUser else {
            return
        }

        nickNameTF.text = selectedProfile.nickname
        linkTF.text = selectedProfile.zoomlink
        imageURL = selectedProfile.profileURL ?? ""
        
        loadProfileImage()
        

        // Do any additional setup after loading the view.
    }
    
    func loadProfileImage() {
        
        
        if imageURL != "" {
            
            
            
            let imagePath = URL(string: imageURL)!
            
            print(imagePath)
            do {
                profilePhoto.image = UIImage(data: try Data(contentsOf: imagePath))
            } catch {}
        }
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
