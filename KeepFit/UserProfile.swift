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
    convenience init(_id: String = "", nickname: String = "", birthday: String = "", height: String = "", weight: String = "", profilePhotoURL: String = "", zoomLink: String = "", streamStarted: Bool = false) {
        
        self.init()
        self._id = _id
        self.nickname = nickname
        self.birthday = birthday
        self.height = height
        self.weight = weight
        self.profilePhotoURL = profilePhotoURL
        self.zoomLink = zoomLink
        self.streamStarted = streamStarted
    }
    

    
    @objc dynamic public var _id: String = ""
    @objc dynamic public var nickname: String = ""
    @objc dynamic public var birthday: String = ""
    @objc dynamic public var height: String = ""
    @objc dynamic public var weight: String = ""
    @objc dynamic public var profilePhotoURL: String = ""
    @objc dynamic public var zoomLink: String = ""
    @objc dynamic public var streamStarted: Bool = false
    
    override static func primaryKey() -> String? {
            return "_id"
    }
    
    
}
