//
//  UserProfileModel.swift
//  KeepFit
//
//  Created by Yi Xu on 3/14/21.
//

import Foundation
import Realm
import RealmSwift

class UserProfileModel: NSObject {
    public var userProfiles: Array<UserProfile> = Array<UserProfile>()
    
    static let shared = UserProfileModel()
    
    // Initiate MongoDB Realm
    let realm = RealmModel.shared.synchronizedRealm
    
    override init() {
        // For testing
//        var testing_profile = UserProfile(account: "User", nickname: "R Pattis", birthday: "12/12", height: "100", weight: "50", profilePhotoURL: "...", zoomLink: "ZoomLink")
//
//        userProfiles.append(testing_profile)
        
        super.init()
        render()
        
    }
    
    func searchForZoomRooms(search_text: String) -> Array<UserProfile> {
        var result = Array<UserProfile>()
        
        
        if search_text == "" {
            return userProfiles
        }
        
        //Cite: https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
        let range = NSRange(location: 0, length: search_text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "\(search_text)")
        for targetUserProfile in userProfiles {
            if regex.firstMatch(in: targetUserProfile.nickname, options: [], range: range) != nil {
                result.append(targetUserProfile)
            }
        
        }
        return result
    }
    
    func numberOfExistingUsers() -> Int {
        return userProfiles.count
    }
    
    func render() {
        let saved_profiles = realm.objects(UserProfile.self)
        
        userProfiles = Array<UserProfile>()
        for saved in saved_profiles {
            userProfiles.append(saved)
        }
        
    }
    
    func createNewProfile(account: String, nickname: String, birthday: String, height: String, weight: String, profilePhotoURL: String) {
        userProfiles.append(UserProfile(account: account, nickname: nickname, birthday: birthday, height: height, weight: weight, profilePhotoURL: profilePhotoURL))
        save()
    }
    
    func save() {
        try! realm.write {
            realm.delete(realm.objects(UserProfile.self))
            
            for userProfile in userProfiles {
                realm.add(userProfile)
            }
        }
    }
}
