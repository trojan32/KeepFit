//
//  LocalRealm.swift
//  KeepFit
//
//  Created by Yi Xu on 3/14/21.
//

import Foundation
import Realm
import RealmSwift

let app = App(id: "keepfit-tmuzu")

class RealmModel {
    
    // Cite: https://stackoverflow.com/questions/41977952/how-to-create-a-custom-realm-file
    
    public let localRealm: Realm = {
        () -> Realm in
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("localRealm.realm")
        config.objectTypes = []
        let land = try! Realm(configuration: config)
        return land
}()
    
    public var synchronizedRealm: Realm? = nil 
    
    public func connectToRemoteRealm() {
        let user = app.currentUser!
        let partitionValue = "keepfitpartition"
        var configuration = user.configuration(partitionValue: partitionValue)


        configuration.fileURL = configuration.fileURL!.deletingLastPathComponent().appendingPathComponent("synchronizedRealm.realm")
        configuration.objectTypes = [UserProfile.self]
        let land = try! Realm(configuration: configuration)
        print("Opened remote realm: \(land)")
        synchronizedRealm = land
    }
    
    
    static let shared = RealmModel()
    
    
}



