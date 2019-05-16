//
//  Video_TubeUITests.swift
//  Video_TubeUITests
//
//  Created by Keval Patel on 5/15/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import XCTest

class Video_TubeUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    /**
     Test for the floating window.
     */
    func testFloatingWindow(){
        let app = XCUIApplication()
        let tableVideostableviewTable = app.tables["table--VideosTableView"]
        tableVideostableviewTable/*@START_MENU_TOKEN@*/.staticTexts["What runs your shop?"]/*[[".cells.staticTexts[\"What runs your shop?\"]",".staticTexts[\"What runs your shop?\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tableVideostableviewTable/*@START_MENU_TOKEN@*/.staticTexts["Parts Procurement with Tom Wood Collision"]/*[[".cells.staticTexts[\"Parts Procurement with Tom Wood Collision\"]",".staticTexts[\"Parts Procurement with Tom Wood Collision\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tableVideostableviewTable/*@START_MENU_TOKEN@*/.staticTexts["Online Parts Ordering with TRS"]/*[[".cells.staticTexts[\"Online Parts Ordering with TRS\"]",".staticTexts[\"Online Parts Ordering with TRS\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tableVideostableviewTable.staticTexts["Jeanne Silver of CARSTAR on CCC ONE Estimating"].tap()
        app.webViews.children(matching: .other).element.tap()
        let element = app.webViews.children(matching: .other).element
        XCTAssertTrue(element.exists)
        element.tap()
        element/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        element.tap()
    }
    /**
     Test elements of filter functionality
     */
    func testFilter(){
        let filterButton = app.navigationBars["Home"].buttons["Filter"]
        XCTAssert(filterButton.exists)
        filterButton.tap()
        let filterSheet = app.sheets["Select Filter Category"]
        XCTAssert(filterSheet.exists)
        XCTAssert(filterSheet.buttons["Select"].exists)
        XCTAssert(filterSheet.buttons["Cancel"].exists)
        filterSheet.buttons["Cancel"].tap()
    }
    //Turn Off the Internet connectivity and run this test case to check the alertview behaviour
    /**
     Test usecase for Internet Connectivity not available
     */
    func testInternetConnectionUnavailable(){
        let tblVideos = app.tables["table--VideosTableView"]
        XCTAssertTrue(tblVideos.exists, "Video List tableView exists")
        let alertNointernetconnectionavailableAlert = XCUIApplication().alerts["No Internet Connection"]
        alertNointernetconnectionavailableAlert.staticTexts["Please connect your device to Internet"].tap()
        alertNointernetconnectionavailableAlert.buttons["OK"].tap()
    }
}
