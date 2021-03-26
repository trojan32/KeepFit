//
//  UserSnapshot.swift
//  KeepFit
//
//  Created by Yi Xu on 3/26/21.
//

import Foundation

class UserSnapshot {
    internal init(nickname: String, zoomlink: String) {
        self.nickname = nickname
        self.zoomlink = zoomlink
    }
    
    public var nickname: String;
    public var zoomlink: String;
    
    
}
