//
//  DurationPickerView.swift
//  PickerView
//
//  Created by Miles Hollingsworth on 11/24/15.
//  Copyright © 2015 Miles Hollingsworth. All rights reserved.
//

import UIKit

private let componentWidth = CGFloat(50.0)
private let reelRepititions = 1000

public class DurationPickerView: UIPickerView {
    public  var  maximumDuration: NSTimeInterval = 0.0 {
        didSet {
            setNeedsDisplay()

            reloadAllComponents()
            
            (1..<numberOfComponents).forEach({ (index) in
                selectRow(60*reelRepititions/2, inComponent: index, animated: false)
            })
        }
    }
    
    weak public var durationDelegate: DurationPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    private func setUp() {
        dataSource = self
        delegate = self
    }
    
    public override func drawRect(rect: CGRect) {
        let center = CGPointMake(self.bounds.width/2, self.bounds.height/2)
        let firstLabelTranslation = CGAffineTransformMakeTranslation(-CGFloat(numberOfComponents)/2.0*componentWidth+30.0, -8.0) // Move left half of width - 30.0, up 8.0
        let firstLabelLeft = CGPointApplyAffineTransform(center, firstLabelTranslation)
        
        
        for index in 0..<numberOfComponents {
            var labelText: String?
            
            switch(numberOfComponents-index) {
            case 1:
                labelText = "s"
            case 2:
                labelText = "m"
            case 3:
                labelText = "h"

            default:
                print("Unhandled label")
            }
            
            let labelLeft = CGPointApplyAffineTransform(firstLabelLeft, CGAffineTransformMakeTranslation(55.0*CGFloat(index), 0.0))
            
            labelText?.drawAtPoint(labelLeft, withAttributes: [
                NSFontAttributeName: UIFont.systemFontOfSize(14.0, weight: UIFontWeightSemibold),
                ])
        }
    }
    
    internal var selectedDuration: NSTimeInterval {
        return (0..<numberOfComponents).reduce(NSTimeInterval(0.0)) { (acc, index) -> NSTimeInterval in
            let componentPlaceValue = placeValueForComponent(index)
            var row = selectedRowInComponent(index)
            
            if componentPlaceValue != 60*60 {
                row %= 60
            }
            return acc + NSTimeInterval(row*componentPlaceValue)
        }
    }
}

extension DurationPickerView: UIPickerViewDataSource {
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return maximumDuration > 0 ?
            min(3, Int(log(Float(maximumDuration))/log(60.0))+1) : 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let componentPlaceValue = placeValueForComponent(component)
        
        let numberOfRows = min(Int(maximumDuration)/componentPlaceValue+1, 60)
        return numberOfRows < 60 ? numberOfRows : 60*reelRepititions
    }
}

extension DurationPickerView: UIPickerViewDelegate {
    public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        
        let padding = 3
        
        var string = self.numberOfComponents == 3 && component == 0 ? // Don't modulo hours
            String(format:"%d", row) : String(format:"%d", row%60)
        
        string += String(count: padding, repeatedValue: ("_" as Character))
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.clearColor()
        ]
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(attributes, range: NSMakeRange(string.characters.count-padding, padding))
        
        label.attributedText = attributedString
        label.textAlignment = .Right
        
        return label
    }
    
    public func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return componentWidth
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedDuration > maximumDuration { // overshot maximumDuration
            let componentPlaceValue = placeValueForComponent(component)
            let targetRow = Int(maximumDuration)%(componentPlaceValue*60)/componentPlaceValue
            var overshoot = row%60-targetRow
            
            if Int(selectedDuration) - overshoot*componentPlaceValue > Int(maximumDuration) {
                overshoot+=1 // increase by 1 in case component to the right is too high
            }
            
            if overshoot>30 {
                overshoot-=60 // make negative to select closest row
            }
            
            selectRow(row-overshoot, inComponent: component, animated: true)
        }
        
        durationDelegate?.pickerView(self, didChangeToValue: selectedDuration)
    }
    
    private func placeValueForComponent(component: Int) -> Int {
        return Int(pow(Float(60), Float(numberOfComponents-component-1)))
    }
}

@objc public protocol DurationPickerViewDelegate: class {
    func pickerView(pickerView: DurationPickerView, didChangeToValue value: NSTimeInterval)
}