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
    @objc dynamic public var account: String = ""
    @objc dynamic public var nickname: String = ""
    @objc dynamic public var birthday: String = ""
    @objc dynamic public var height: String = ""
    @objc dynamic public var weight: String = ""
    @objc dynamic public var profilePhotoURL: String = ""
    
}
