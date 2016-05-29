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
        
        durationPickerView.awakeFromNib()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialDurationIsZero() {
        XCTAssertEqual(durationPickerView.selectedDuration, 0)
    }
    
    func testZeroDurationNumberOfComponents() {
        XCTAssertEqual(durationPickerView.numberOfComponents, 1)
    }
    
    func testSubMinuteDurationNumberOfComponents() {
        durationPickerView.maximumDuration = 30
        
        XCTAssertEqual(durationPickerView.numberOfComponents, 1)
    }
    
    func testSubMinuteDurationNumberOfRows() {
        durationPickerView.maximumDuration = 30
        
        XCTAssertEqual(durationPickerView.numberOfRowsInComponent(0), 31)
    }
    
    func testMinuteDurationNumberOfComponents() {
        durationPickerView.maximumDuration = 60
        
        XCTAssertEqual(durationPickerView.numberOfComponents, 2)
    }
    
    func testMinuteDurationNumberOfRows() {
        durationPickerView.maximumDuration = 60
        
        XCTAssertEqual(durationPickerView.numberOfRowsInComponent(0), 2)
    }
    
    func testSubHourDurationNumberOfComponents() {
        durationPickerView.maximumDuration = 360
        XCTAssertEqual(durationPickerView.numberOfComponents, 2)
    }
    
    func testSubHourDurationNumberOfRows() {
        durationPickerView.maximumDuration = 360
        
        XCTAssertEqual(durationPickerView.numberOfRowsInComponent(0), 7)
    }
    
    func testHourDurationNumberOfComponents() {
        durationPickerView.maximumDuration = 3600
        
        XCTAssertEqual(durationPickerView.numberOfComponents, 3)
    }
    
    func testHourDurationNumberOfRows() {
        durationPickerView.maximumDuration = 3600

        XCTAssertEqual(durationPickerView.numberOfRowsInComponent(0), 2)

    }
}
