//
//  Video_TubeTests.swift
//  Video_TubeTests
//
//  Created by Keval Patel on 5/15/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import XCTest
@testable import Video_Tube


class Video_TubeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConvertDateStringToTimeStamp() {
        let dateString = "2014-07-16T17:49:54.000Z"
        XCTAssertEqual(dateString.convertDateStringToTimeStamp(), 1405532994.0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
