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

}
