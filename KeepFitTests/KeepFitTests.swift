//
//  KeepFitTests.swift
//  KeepFitTests
//
//  Created by Yi Xu on 2/22/21.
//

import XCTest
@testable import KeepFit

class KeepFitTests: XCTestCase {


    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUserSnapshoNilInit() {
        // Make sure that when User Snapshot is initialized using nil arguments, it won't crash and it will be handled appropriately.
        
        let snapshot = UserSnapshot(nickname: nil, zoomlink: nil)
        XCTAssertNil(snapshot.nickname)
        XCTAssertNil(snapshot.zoomlink)
    }
    
    func testUserSnapshotEmptyStringInit() {
        // Make sure that when User Snapshot is initialized using empty string arguments, it won't crash and it will be handled appropriately.
        
        let snapshot = UserSnapshot(nickname: "", zoomlink: "")
        XCTAssertEqual(snapshot.nickname, "")
        XCTAssertEqual(snapshot.zoomlink, "")
    }
    
    func testPersonalAccountModelInit() {
        // Tests that the PersonalAccountModel can be initialized with no given argument
        XCTAssertNoThrow(PersonalAccountModel.init())
    }

    func testSharedPersonalAccountModel() {
        // Tests the singleton pattern of the personal account model. Wherever change is made to the model, the change will be reflected in every other model in different references.
        
        let model1 = PersonalAccountModel.shared
        let model2 = PersonalAccountModel.shared
        model1.loggedIn = true
        XCTAssertEqual(model1.loggedIn, PersonalAccountModel.shared.loggedIn)
        XCTAssertEqual(model1.loggedIn, model2.loggedIn)
    }
    
    func testPersonalAccountModelLogout() {
        // Tests that the PersonalAccountModel can successfully log out a user
        let model = PersonalAccountModel.shared
        model.loggedIn = true
        model.logOutOfAccount()
        XCTAssertFalse(model.loggedIn)
    }
    
    

}
