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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedProfile = StreamPageTableViewController.selectedProfile else {
            return
        }
        
        nickNameTF.text = selectedProfile.nickname
        linkTF.text = selectedProfile.zoomLink
        

        // Do any additional setup after loading the view.
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
