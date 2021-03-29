//
//  KeepFitUITests.swift
//  KeepFitUITests
//
//  Created by Yi Xu on 2/22/21.
//


// Cite: ITP 342 Course Materials

import XCTest
import Firebase
import FirebaseAuth

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
        
        logIn(accountText: "nealight@gmail.com", passwordText: "password123@")
        
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
    
    // another problem is that clear textfields functionality hasn't been implemented
    func testChangeAccountInfo() {
        logOutIfLoggedIn()
        logIn(accountText: "test7@gmail.com", passwordText: "test1234*")
        accountInfoUpdate(nickname: "new", birthday:"0101")
        
        sleep(6)
        
        XCTAssertEqual(app.staticTexts["profileNicknameLabel"].label, "test7new")
        XCTAssertEqual(app.staticTexts["profileBirthdayLabel"].label, "Birthday: 199901010101")
        XCTAssertEqual(app.staticTexts["profileWeightLabel"].label, "Weight: 52 kg")
        XCTAssertEqual(app.staticTexts["profileHeightLabel"].label, "Height: 178 cm")
        
//        accountInfoUpdate(nickname: "test7", birthday: "19990101")
    }
    
    func testPasswordUpdateSuccess() {
        logOutIfLoggedIn()
        logIn(accountText: "testpw@gmail.com", passwordText: "test1234*")
        passwordUpdate(password: "test1234**")
        
        logOut()
        logIn(accountText: "testpw@gmail.com", passwordText: "test1234**")
        XCTAssertTrue(app.buttons["profileLogoutButton"].exists)
        passwordUpdate(password: "test1234*")
        
        
    }
    
    func testPasswordUpdateFailed() {
        logOutIfLoggedIn()
        logIn(accountText: "testpw@gmail.com", passwordText: "test1234*")
        passwordUpdate(password: "test1234")
        passwordUpdate(password: "testtest")
        passwordUpdate(password: "tt1234*")
        
        logOut()
        logIn(accountText: "testpw@gmail.com", passwordText: "test1234*")
        XCTAssertTrue(app.buttons["profileLogoutButton"].exists)
    }
    
    // error with deleting user
    func testCreateUserUIElementsShowingCorrectly() {
        logOutIfLoggedIn()
        switchToPage(page: "Profile")
        let createAccountButton = app.buttons["profileCreateAccountButton"]
        createAccountButton.tap()
        
        let emailTF = app.textFields["profileCEmailTF"]
        let passwordTF = app.textFields["profileCPasswordTF"]
        let nicknameTF = app.textFields["profileCNicknameTF"]
        let birthdayTF = app.textFields["profileCBirthdayTF"]
        let heightTF = app.textFields["profileCHeightTF"]
        let weightTF = app.textFields["profileCWeightTF"]
        
        createAccountTypeFields(textField: emailTF, text: "testCU@gmail.com")
        createAccountTypeFields(textField: passwordTF, text: "test1234*")
        createAccountTypeFields(textField: nicknameTF, text: "testCU")
        createAccountTypeFields(textField: birthdayTF, text: "22220222")
        createAccountTypeFields(textField: heightTF, text: "14")
        createAccountTypeFields(textField: weightTF, text: "15")
        
        let createButton = app.buttons["profileCCreateButton"]
        
        
        
        
    }
    
    func testCreateUserEmptyFields() {
        logOutIfLoggedIn()
        switchToPage(page: "Profile")
        let createAccountButton = app.buttons["profileCreateAccountButton"]
        createAccountButton.tap()
        
        let emailTF = app.textFields["profileCEmailTF"]
        let passwordTF = app.textFields["profileCPasswordTF"]
        let nicknameTF = app.textFields["profileCNicknameTF"]
        let birthdayTF = app.textFields["profileCBirthdayTF"]
        let heightTF = app.textFields["profileCHeightTF"]
        
        createAccountTypeFields(textField: emailTF, text: "testCU@gmail.com")
        createAccountTypeFields(textField: passwordTF, text: "test1234*")
        createAccountTypeFields(textField: nicknameTF, text: "testCU")
        createAccountTypeFields(textField: birthdayTF, text: "22220222")
        createAccountTypeFields(textField: heightTF, text: "15")
        
        let createButton = app.buttons["profileCCreateButton"]
        createButton.tap()
        
        sleep(6)
        
        let errorMessage = app.staticTexts["profileCErrorLabel"].label
        XCTAssertEqual(errorMessage, "Please fill in all fields.")
        
    }
    
    // clear text fields functionality required
    func testCreateUserInvalidPassword() {
        logOutIfLoggedIn()
        switchToPage(page: "Profile")
        let createAccountButton = app.buttons["profileCreateAccountButton"]
        createAccountButton.tap()
        
        let emailTF = app.textFields["profileCEmailTF"]
        let passwordTF = app.textFields["profileCPasswordTF"]
        let nicknameTF = app.textFields["profileCNicknameTF"]
        let birthdayTF = app.textFields["profileCBirthdayTF"]
        let heightTF = app.textFields["profileCHeightTF"]
        let weightTF = app.textFields["profileCWeightTF"]
        
        createAccountTypeFields(textField: emailTF, text: "testCU@gmail.com")
        createAccountTypeFields(textField: passwordTF, text: "test1234")
        createAccountTypeFields(textField: nicknameTF, text: "testCU")
        createAccountTypeFields(textField: birthdayTF, text: "22220222")
        createAccountTypeFields(textField: heightTF, text: "14")
        createAccountTypeFields(textField: weightTF, text: "15")
        
        let createButton = app.buttons["profileCCreateButton"]
        createButton.tap()
        
        sleep(6)
        
        let errorMessage = app.staticTexts["profileCErrorLabel"].label
        XCTAssertEqual(errorMessage, "Please make sure your password is at least 8 characters, contains a special character and a number.")
        
    }
    
    func testCreateUserInvalidEmail() {
        logOutIfLoggedIn()
        switchToPage(page: "Profile")
        let createAccountButton = app.buttons["profileCreateAccountButton"]
        createAccountButton.tap()
        
        let emailTF = app.textFields["profileCEmailTF"]
        let passwordTF = app.textFields["profileCPasswordTF"]
        let nicknameTF = app.textFields["profileCNicknameTF"]
        let birthdayTF = app.textFields["profileCBirthdayTF"]
        let heightTF = app.textFields["profileCHeightTF"]
        let weightTF = app.textFields["profileCWeightTF"]
        
        createAccountTypeFields(textField: emailTF, text: "testCU")
        createAccountTypeFields(textField: passwordTF, text: "test1234*")
        createAccountTypeFields(textField: nicknameTF, text: "testCU")
        createAccountTypeFields(textField: birthdayTF, text: "22220222")
        createAccountTypeFields(textField: heightTF, text: "14")
        createAccountTypeFields(textField: weightTF, text: "15")
        
        let createButton = app.buttons["profileCCreateButton"]
        createButton.tap()
        
        sleep(6)
        
        let errorMessage = app.staticTexts["profileCErrorLabel"].label
        XCTAssertEqual(errorMessage, "Error creating user")
        
    }
    
    func testCreateUserInvalidHeight() {
            logOutIfLoggedIn()
            switchToPage(page: "Profile")
            let createAccountButton = app.buttons["profileCreateAccountButton"]
            createAccountButton.tap()
            
            let emailTF = app.textFields["profileCEmailTF"]
            let passwordTF = app.textFields["profileCPasswordTF"]
            let nicknameTF = app.textFields["profileCNicknameTF"]
            let birthdayTF = app.textFields["profileCBirthdayTF"]
            let heightTF = app.textFields["profileCHeightTF"]
            let weightTF = app.textFields["profileCWeightTF"]
            
            createAccountTypeFields(textField: emailTF, text: "testCU@gmail.com")
            createAccountTypeFields(textField: passwordTF, text: "test1234")
            createAccountTypeFields(textField: nicknameTF, text: "testCU")
            createAccountTypeFields(textField: birthdayTF, text: "22220222")
            createAccountTypeFields(textField: heightTF, text: "string")
            createAccountTypeFields(textField: weightTF, text: "15")
            
            let createButton = app.buttons["profileCCreateButton"]
            createButton.tap()
            
            sleep(6)
            
            let errorMessage = app.staticTexts["profileCErrorLabel"].label
            XCTAssertEqual(errorMessage, "Please fill in a number for height.")
            
        }
        
        
        func testCreateUserInvalidWeight() {
            logOutIfLoggedIn()
            switchToPage(page: "Profile")
            let createAccountButton = app.buttons["profileCreateAccountButton"]
            createAccountButton.tap()
            
            let emailTF = app.textFields["profileCEmailTF"]
            let passwordTF = app.textFields["profileCPasswordTF"]
            let nicknameTF = app.textFields["profileCNicknameTF"]
            let birthdayTF = app.textFields["profileCBirthdayTF"]
            let heightTF = app.textFields["profileCHeightTF"]
            let weightTF = app.textFields["profileCWeightTF"]
            
            createAccountTypeFields(textField: emailTF, text: "testCU@gmail.com")
            createAccountTypeFields(textField: passwordTF, text: "test1234")
            createAccountTypeFields(textField: nicknameTF, text: "testCU")
            createAccountTypeFields(textField: birthdayTF, text: "22220222")
            createAccountTypeFields(textField: heightTF, text: "14")
            createAccountTypeFields(textField: weightTF, text: "string")
            
            let createButton = app.buttons["profileCCreateButton"]
            createButton.tap()
            
            sleep(6)
            
            let errorMessage = app.staticTexts["profileCErrorLabel"].label
            XCTAssertEqual(errorMessage, "Please fill in a number for weight.")
            
        }
    
    func testPlayVideo()
    {
//        logOutIfLoggedIn()
        switchToPage(page: "Item")
        app/*@START_MENU_TOKEN@*/.buttons["Video"].staticTexts["Video"]/*[[".buttons[\"Video\"].staticTexts[\"Video\"]",".staticTexts[\"Video\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        
        let tablesQuery = app.tables
        XCTAssertNoThrow(tablesQuery/*@START_MENU_TOKEN@*/.cells.staticTexts["Dashanghuahuo"]/*[[".cells.staticTexts[\"Dashanghuahuo\"]",".staticTexts[\"Dashanghuahuo\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap())
        sleep(10)
    }
    
        
        
        
        

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    func switchToPage(page: String) {
        let tabBarsQuery = XCUIApplication().tabBars
        tabBarsQuery.buttons[page].firstMatch.tap()
    }
    
    func logOut() {
        switchToPage(page: "Profile")
        let profileLogoutButton = app.buttons["profileLogoutButton"]
        profileLogoutButton.tap()
    }
    
    func logOutIfLoggedIn() {
        switchToPage(page: "Profile")
        let loginButton = app.buttons["profileSigninButton"]
        if !loginButton.exists {
            print("Logging out")
        
            
            let profileLogoutButton = self.app.buttons["profileLogoutButton"]
                profileLogoutButton.tap()
            
        } else {
            app.buttons["profileCancelButton"].tap()
        }
    }
    
    func logIn(accountText: String, passwordText: String) {
        sleep(6)
        let loginButton = app.buttons["profileSigninButton"]
        if !loginButton.exists {
            switchToPage(page: "Profile")
        }
        let accountTF = app.textFields["profileEmailTF"]
        let passwordTF = app.textFields["profilePasswordTF"]
        accountTF.tap()
        accountTF.typeText(accountText)
        sleep(1)
        passwordTF.tap()
        passwordTF.typeText(passwordText)
        loginButton.tap()
        
        sleep(6)
    }
    
    func accountInfoUpdate(nickname: String, birthday: String) {
        let changeAccountInfoButton = app.buttons["profileChangeAccountInfoButton"]
        changeAccountInfoButton.tap()
        let nicknameTF = app.textFields["profileNicknameTF"]
        let birthdayTF = app.textFields["profileBirthdayTF"]
        
        nicknameTF.tap()
        nicknameTF.typeText(nickname)
        
        birthdayTF.tap()
        birthdayTF.typeText(birthday)
        
        app.staticTexts["profileEditProfileLabel"].tap()
        
        let updateButton = app.buttons["profileUpdateButton"]
        updateButton.tap()
        
        app.swipeDown()
        
        switchToPage(page: "Community")
        switchToPage(page: "Profile")
    }
    
    func passwordUpdate(password: String) {
        let changeAccountInfoButton = app.buttons["profileChangeAccountInfoButton"]
        changeAccountInfoButton.tap()
        let passwordTF = app.textFields["profilePasswordTF"]
        
        passwordTF.tap()
        passwordTF.typeText(password)
        
        app.staticTexts["profileEditProfileLabel"].tap()
        
        let updateButton = app.buttons["profileUpdateButton"]
        updateButton.tap()
        
        app.swipeDown()
        
        
    }
    
    func createAccountTypeFields(textField: XCUIElement, text: String) {
        textField.tap()
        textField.typeText(text)
        app.staticTexts["profileCHeadlineLabel"].tap()
    }
    
    func deleteUser() {
       
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
