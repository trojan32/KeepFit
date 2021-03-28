//
//  PersonalAccountModel.swift
//  KeepFit
//
//  Created by Yi Xu on 3/13/21.
//
// Cite: https://github.com/nealight/Apply

import Foundation
import Realm
import RealmSwift

class PersonalAccountModel {
    public var personalAccount: PersonalAccount = PersonalAccount()
    public var loggedIn: Bool = false
    
    
    
    public var myAccountProfile: UserProfile? = nil
    
    // Swift Singleton pattern
    static let shared = PersonalAccountModel()
    
    // Initiate MongoDB Realm
//    let realm = RealmModel.shared.localRealm
    
    init() {
        // Debugging code for Realm
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        let filepath = url!.path
        print("filepath=\(filepath)")
        
        
        
        
        
        
    }
    

    
    func EditZoomLink(link: String) {
        
        guard let profile = myAccountProfile else {
            return
        }
        
        UserProfileModel.shared.updateProfileToRealm(targetUserProfile: profile, link: link)
    }
    
    func createNewAccount(account: String, password: String, nickname: String, birthday: String, height: String, weight: String, profilePhotoURL: String) {
        
        
        UserProfileModel.shared.createNewProfile(account: account, nickname: nickname, birthday: birthday, height: height, weight: weight, profilePhotoURL: profilePhotoURL)
    }
    
    func logIntoAccount(account: String, password: String) -> Bool {
        // Need to have actual authentication below
        
        guard let targetProfile: UserProfile = UserProfileModel.shared.authenticate(account: account, password: password) else {
            return false
        }
        
        // Need to have actual authentication above
        
        
    
        
        loggedIn = true
        myAccountProfile = targetProfile
        personalAccount = PersonalAccount(account: targetProfile._id, password: targetProfile._id, nickname: targetProfile.nickname, birthday: targetProfile.birthday, height: targetProfile.height, weight: targetProfile.weight, profilePhotoURL: targetProfile.profilePhotoURL)
        
        
     
        
        
        return true
    }
    
    func logOutOfAccount() -> Bool {
        loggedIn = false
        
        return true
    }
    
}
