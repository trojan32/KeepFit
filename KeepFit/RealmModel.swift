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
        config.objectTypes = [PersonalAccount.self]
        let land = try! Realm(configuration: config)
        return land
}()
    
    public var synchronizedRealm: Realm? = nil // = {
//        () -> Realm in
//
//        let login = app.login(credentials: Credentials.emailPassword(email: "test@test.com", password: "testtest"))  { (result) in
//            switch result {
//            case .failure(let error):
//                print("Login failed: \(error)")
//            case .success(let user):
//                print("Login as \(user) succeeded!")
//            }
//        }
//
//        let user = app.currentUser!
//        let partitionValue = "keepfitpartition"
//        var configuration = user.configuration(partitionValue: partitionValue)
//
//
//        configuration.fileURL = configuration.fileURL!.deletingLastPathComponent().appendingPathComponent("synchronizedRealm.realm")
//        configuration.objectTypes = [UserProfile.self]
//        let land = try! Realm(configuration: configuration)
//        print("Opened realm: \(land)")
//
//
//
//        return land
//}()
    
    public func connectToRemoteRealm() {
        let user = app.currentUser!
        let partitionValue = "keepfitpartition"
        var configuration = user.configuration(partitionValue: partitionValue)


        configuration.fileURL = configuration.fileURL!.deletingLastPathComponent().appendingPathComponent("synchronizedRealm.realm")
        configuration.objectTypes = [UserProfile.self]
        let land = try! Realm(configuration: configuration)
        print("Opened realm: \(land)")
        synchronizedRealm = land
    }
    
    
    static let shared = RealmModel()
    
    
}

// private api key: 32f65951-8c04-44a0-b515-a6a699bb4b2b
// public api key: BUXJHHXJ
// real-app id: tasktracker-xwbdh


