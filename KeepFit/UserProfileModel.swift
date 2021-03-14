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
    
    
    override init() {
    
    }
}
