//
//  UserProfileModel.swift
//  KeepFit
//
//  Created by Yi Xu on 3/14/21.
//

import Foundation
import Realm
import RealmSwift

class UserProfileModel{
    public var userProfiles: Array<UserProfile> = Array<UserProfile>()
    
    static let shared = UserProfileModel()
    
    // Initiate MongoDB Realm
    
    init() {
        // For testing
//        var testing_profile = UserProfile(account: "User", nickname: "R Pattis", birthday: "12/12", height: "100", weight: "50", profilePhotoURL: "...", zoomLink: "ZoomLink")
//
//        userProfiles.append(testing_profile)
        
        
        app.login(credentials: Credentials.anonymous) { (result) in
            // Remember to dispatch back to the main thread in completion handlers
            // if you want to do anything on the UI.
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Login failed: \(error)")
                case .success(let user):
                    print("Login as \(user) succeeded!")
                }
                    
                RealmModel.shared.connectToRemoteRealm()
                
            }
        }
        
        
        
    }
    
    func searchForZoomRooms(search_text: String) -> Array<UserProfile> {
        var result = Array<UserProfile>()
        
        
        if search_text == "" {
            return userProfiles
        }
        
        //Cite: https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
        
        let regex = try! NSRegularExpression(pattern: "\(search_text)")
        
        for targetUserProfile in userProfiles {
            let range = NSRange(location: 0, length: targetUserProfile.nickname.utf16.count)
            if regex.firstMatch(in: targetUserProfile.nickname, options: [], range: range) != nil {
                result.append(targetUserProfile)
            }
        
        }
        return result
    }
    
    func numberOfExistingUsers() -> Int {
        return userProfiles.count
    }
    
    public func render() {
        let saved_profiles = RealmModel.shared.synchronizedRealm!.objects(UserProfile.self)
        
        userProfiles = Array<UserProfile>()
        for saved in saved_profiles {
            userProfiles.append(saved)
        }
        
    }
    
    func createNewProfile(account: String, nickname: String, birthday: String, height: String, weight: String, profilePhotoURL: String) {
        let targetUserProfile = UserProfile(account: account, nickname: nickname, birthday: birthday, height: height, weight: weight, profilePhotoURL: profilePhotoURL)
        userProfiles.append(targetUserProfile)
        appendProfileToRealm(targetUserProfile: targetUserProfile)
    }
    
    func appendProfileToRealm(targetUserProfile: UserProfile) {
        try! RealmModel.shared.synchronizedRealm!.write {
            
            RealmModel.shared.synchronizedRealm!.add(targetUserProfile)
            
        }
    }
}
