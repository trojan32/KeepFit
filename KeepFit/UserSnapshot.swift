//
//  UserSnapshot.swift
//  KeepFit
//
//  Created by Yi Xu on 3/26/21.
//

import Foundation

class UserSnapshot {
    var nickname: String?
    var zoomlink: String?
    var profileURL: String?
    
    init(nickname: String?, zoomlink: String?, profileURL: String?) {
        self.nickname = nickname
        self.zoomlink = zoomlink
        self.profileURL = profileURL
    }
}
