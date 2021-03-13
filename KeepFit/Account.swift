//
//  Account.swift
//  KeepFit
//
//  Created by Yi Xu on 3/13/21.
//


// Cite: https://github.com/nealight/Apply

import Foundation

import Realm
import RealmSwift

class Account: Object {
    convenience init(account: String = "", password: String = "", nickname: String = "", birthday: String = "", height: String = "", weight: String = "", profilePhotoURL: String = "") {
        self.init()
        self.account = account
        self.password = password
        self.nickname = nickname
        self.birthday = birthday
        self.height = height
        self.weight = weight
        self.profilePhotoURL = profilePhotoURL
    }
    
    @objc dynamic public var account: String = ""
    @objc dynamic public var password: String = ""
    @objc dynamic public var nickname: String = ""
    @objc dynamic public var birthday: String = ""
    @objc dynamic public var height: String = ""
    @objc dynamic public var weight: String = ""
    @objc dynamic public var profilePhotoURL: String = ""
    
    
    
    

    
    
}

