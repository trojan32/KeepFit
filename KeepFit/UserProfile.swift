//
//  UserProfile.swift
//  KeepFit
//
//  Created by Yi Xu on 3/14/21.
//

import Foundation
import RealmSwift
import Realm

class UserProfile: Object {
    convenience init(account: String = "", nickname: String = "", birthday: String = "", height: String = "", weight: String = "", profilePhotoURL: String = "", zoomLink: String = "") {
        self.init()
        self.account = account
        self.nickname = nickname
        self.birthday = birthday
        self.height = height
        self.weight = weight
        self.profilePhotoURL = profilePhotoURL
        self.zoomLink = zoomLink
    }
    
    @objc dynamic public var account: String = ""
    @objc dynamic public var nickname: String = ""
    @objc dynamic public var birthday: String = ""
    @objc dynamic public var height: String = ""
    @objc dynamic public var weight: String = ""
    @objc dynamic public var profilePhotoURL: String = ""
    @objc dynamic public var zoomLink: String = ""
    
    
}
