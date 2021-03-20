//
//  MyStreamingViewController.swift
//  KeepFit
//
//  Created by Yi Xu on 3/20/21.
//

import UIKit

class MyStreamingViewController: UIViewController {
    
    let profileModel = UserProfileModel.shared
    let personalAccountModel = PersonalAccountModel.shared
    
    @IBOutlet var zoomLinkTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        zoomLinkTF.text = personalAccountModel.myAccountProfile?.zoomLink
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func zoomLinkModified(_ sender: UITextField) {
        personalAccountModel.EditZoomLink(link: sender.text ?? "")
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
