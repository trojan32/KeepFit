//
//  PersonalAccountModel.swift
//  KeepFit
//
//  Created by Yi Xu on 3/13/21.
//
// Cite: https://github.com/nealight/Apply

import Foundation
import Realm
import RealmSwift

class PersonalAccountModel: NSObject {
    public var personalAccount: Account = Account()
    public var loggedIn: Bool = false
    
    // Swift Singleton pattern
    static let shared = PersonalAccountModel()
    
    // Initiate MongoDB Realm
    let realm = try! Realm()
    
    override init() {
        // Debugging code for Realm
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        let filepath = url!.path
        print("filepath=\(filepath)")
        
        super.init()
        render()
    }
    
    func render() {
        let saved_account = realm.objects(Account.self)
        
        for saved in saved_account {
            personalAccount = saved
        }
        
    }
    
    func save() {
        try! realm.write {
            realm.delete(realm.objects(Account.self))
            
            realm.add(personalAccount)
        }
    }
    
    func createNewAccount(account: String, password: String, nickname: String, birthday: String, height: String, weight: String, profilePhotoURL: String) {
        personalAccount = Account(account: account, password: password, nickname: nickname, birthday: birthday, height: height, weight: weight, profilePhotoURL: profilePhotoURL)
        save()
    }
    
}
