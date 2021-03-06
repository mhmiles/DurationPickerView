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
        
        XCTAssertEqual(durationPickerView.numberOfRows(inComponent: 0), 31)
    }
    
    func testSubMinuteDurationSelection() {
        durationPickerView.maximumDuration = 30
        durationPickerView.selectRow(20, inComponent: 0, animated: false)
        
        XCTAssertEqual(durationPickerView.selectedDuration, 20)
    }
    
    func testMinuteDurationNumberOfComponents() {
        durationPickerView.maximumDuration = 60
        
        XCTAssertEqual(durationPickerView.numberOfComponents, 2)
    }
    
    func testMinuteDurationNumberOfRows() {
        durationPickerView.maximumDuration = 60
        
        XCTAssertEqual(durationPickerView.numberOfRows(inComponent: 0), 2)
    }
    
    func testMinuteDurationSelection() {
        durationPickerView.maximumDuration = 60
        durationPickerView.selectRow(1, inComponent: 0, animated: false)
        durationPickerView.selectRow(60*600, inComponent: 1, animated: false)
        
        XCTAssertEqual(durationPickerView.selectedDuration, 60)
    }
    
    func testSubHourDurationNumberOfComponents() {
        durationPickerView.maximumDuration = 360
        XCTAssertEqual(durationPickerView.numberOfComponents, 2)
    }
    
    func testSubHourDurationNumberOfRows() {
        durationPickerView.maximumDuration = 360
        
        XCTAssertEqual(durationPickerView.numberOfRows(inComponent: 0), 7)
    }
    
    func testSubHourDurationSelection() {
        durationPickerView.maximumDuration = 360
        durationPickerView.selectRow(4, inComponent: 0, animated: false)
        durationPickerView.selectRow(60*600+4, inComponent: 1, animated: false)
        
        XCTAssertEqual(durationPickerView.selectedDuration, 244)
    }
    
    func testHourDurationNumberOfComponents() {
        durationPickerView.maximumDuration = 3600
        
        XCTAssertEqual(durationPickerView.numberOfComponents, 3)
    }
    
    func testHourDurationNumberOfRows() {
        durationPickerView.maximumDuration = 3600

        XCTAssertEqual(durationPickerView.numberOfRows(inComponent: 0), 2)
    }
    
    func testHourDurationSelection() {
        durationPickerView.maximumDuration = 3600
        durationPickerView.selectRow(1, inComponent: 0, animated: false)
        durationPickerView.selectRow(60*600, inComponent: 1, animated: false)
        durationPickerView.selectRow(60*600, inComponent: 2, animated: false)
        
        XCTAssertEqual(durationPickerView.selectedDuration, 3600)
    }
    
    func testOvershootDetection() {
        durationPickerView.maximumDuration = 3600
        durationPickerView.selectRow(1, inComponent: 0, animated: false)
        durationPickerView.selectRow(60*600+4, inComponent: 1, animated: false)
        
        durationPickerView.pickerView(durationPickerView, didSelectRow: durationPickerView.selectedRow(inComponent: 1), inComponent: 1)
        
        XCTAssertEqual(durationPickerView.selectedDuration, 3600)
    }
    
    func testOvershootEdgeCase() {
        durationPickerView.maximumDuration = 3840
        durationPickerView.selectRow(1, inComponent: 0, animated: false)
        durationPickerView.selectRow(1, inComponent: 2, animated: false)
        durationPickerView.selectRow(4, inComponent: 1, animated: false)
        
        durationPickerView.pickerView(durationPickerView, didSelectRow: durationPickerView.selectedRow(inComponent: 1), inComponent: 1)
        
        XCTAssertEqual(durationPickerView.selectedDuration, 3781)
    }
}
