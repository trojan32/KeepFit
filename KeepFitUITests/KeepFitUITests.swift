//
//  KeepFitUITests.swift
//  KeepFitUITests
//
//  Created by Yi Xu on 2/22/21.
//


// Cite: ITP 342 Course Materials

import XCTest
import Firebase

class KeepFitUITests: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func setUp() {
        super.setUp()
        XCUIDevice.shared.orientation = .portrait
        continueAfterFailure = false
        XCUIApplication().launch()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCanSwitchToOtherPages()  {
        XCTAssertNoThrow(switchToPage(page: "Profile"))
        
    }
    func testProfilePageUIElementsShowingCorrectly()  {
        // UI tests must launch the application that they test.
        
        logOutIfLoggedIn()
        
        switchToPage(page: "Profile")
        
        let loginButton = app.buttons["profileSigninButton"]
//        sleep(3)
        XCTAssertTrue(loginButton.exists)
        
        let accountTF = app.textFields["profileEmailTF"]
        let passwordTF = app.textFields["profilePasswordTF"]
        
        XCTAssertTrue(accountTF.exists)
        XCTAssertTrue(passwordTF.exists)
    }
    
    func testCanLoginWithRightCredentials() {
        
        logOutIfLoggedIn()
        
        switchToPage(page: "Profile")
        let loginButton = app.buttons["profileSigninButton"]
        let accountTF = app.textFields["profileEmailTF"]
        let passwordTF = app.textFields["profilePasswordTF"]
        accountTF.tap()
        accountTF.typeText("nealight@gmail.com")
//        sleep(1)
        passwordTF.tap()
        passwordTF.typeText("password123@")
        loginButton.tap()
        
        sleep(6)
        
        switchToPage(page: "Community")
        switchToPage(page: "Profile")
        XCTAssertTrue(app.buttons["profileLogoutButton"].exists)
        
        
    }
    
    func testCannotLoginWithWrongCredentials() {
        
        logOutIfLoggedIn()
        
        switchToPage(page: "Profile")
        let loginButton = app.buttons["profileSigninButton"]
        let accountTF = app.textFields["profileEmailTF"]
        let passwordTF = app.textFields["profilePasswordTF"]
        accountTF.tap()
        accountTF.typeText("wrong@gmail.com")

        passwordTF.tap()
        passwordTF.typeText("wrongpassword")
        loginButton.tap()

        
        XCTAssertTrue(app.buttons["profileSigninButton"].exists)
        
        
    }
        
        
        
        

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    func switchToPage(page: String) {
        let tabBarsQuery = XCUIApplication().tabBars
        tabBarsQuery.buttons[page].tap()
    }
    
    func logOut() {
        switchToPage(page: "Profile")
        let profileLogoutButton = app.buttons["profileLogoutButton"]
        profileLogoutButton.tap()
    }
    
    func logOutIfLoggedIn() {
        switchToPage(page: "Profile")
        let profileLogoutButton = app.buttons["profileLogoutButton"]
        let loginButton = app.buttons["profileSigninButton"]
        if !loginButton.exists {
            print("Logging out")
        
            
            let profileLogoutButton = self.app.buttons["profileLogoutButton"]
                profileLogoutButton.tap()
            
        } else {
            app.buttons["profileCancelButton"].tap()
        }
        
            
            
            

        
        
    }
//
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
