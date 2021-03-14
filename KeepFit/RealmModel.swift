//
//  LocalRealm.swift
//  KeepFit
//
//  Created by Yi Xu on 3/14/21.
//

import Foundation
import Realm
import RealmSwift

class RealmModel: NSObject {
    
    // Cite: https://stackoverflow.com/questions/41977952/how-to-create-a-custom-realm-file
    
    public let localRealm: Realm = {
        () -> Realm in
    var config = Realm.Configuration()
    config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("localRealm.realm")
    let land = try! Realm(configuration: config)
    return land
}()
    
    public let synchronizedRealm: Realm = {
        () -> Realm in
    var config = Realm.Configuration()
    config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("synchronizedRealm.realm")
    let land = try! Realm(configuration: config)
    return land
}()
    
    static let shared = RealmModel()
    
    override init() {
        
        return
    }
    
}
