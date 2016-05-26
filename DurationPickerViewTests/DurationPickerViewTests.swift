//
//  DurationPickerViewTests.swift
//  DurationPickerViewTests
//
//  Created by Miles Hollingsworth on 5/26/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import XCTest
@testable import DurationPickerView


class DurationPickerViewTests: XCTestCase {
    
    let durationPickerView = DurationPickerView()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialDurationIsZero() {
        XCTAssertEqual(durationPickerView.selectedDuration, 0)
    }
    
    func testSubMinuteDuration() {
        durationPickerView.duration = 30
        XCTAssertEqual(durationPickerView.numberOfComponentsInPickerView(durationPickerView), 1)
    }
    
    func testMinuteDuration() {
        durationPickerView.duration = 60
        XCTAssertEqual(durationPickerView.numberOfComponentsInPickerView(durationPickerView), 2)
    }
    
    func testSubHourDuration() {
        durationPickerView.duration = 360
        XCTAssertEqual(durationPickerView.numberOfComponentsInPickerView(durationPickerView), 2)
    }
    
    func testHourDuration() {
        durationPickerView.duration = 3600
        XCTAssertEqual(durationPickerView.numberOfComponentsInPickerView(durationPickerView), 3)
    }
}
