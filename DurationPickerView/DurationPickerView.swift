//
//  DurationPickerView.swift
//  PickerView
//
//  Created by Miles Hollingsworth on 11/24/15.
//  Copyright © 2015 Miles Hollingsworth. All rights reserved.
//

import UIKit

public class DurationPickerView: UIPickerView {
    public var maximumDuration: NSTimeInterval = 0.0 {
        didSet {
            setNeedsDisplay()
            reloadAllComponents()
            
            if maximumDuration > 60*60 {
                selectRow(60*200, inComponent: 1, animated: false)
                selectRow(60*200, inComponent: 2, animated: false)
            }
        }
    }
    
    weak public var durationDelegate: DurationPickerViewDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }
    
    public override func drawRect(rect: CGRect) {
        let center = CGPointMake(self.bounds.width/2, self.bounds.height/2)
        let firstLabelTranslation = CGAffineTransformMakeTranslation(-CGFloat(numberOfComponents)/2.0*50.0+30.0, -8.0) // Move left half of width - 30.0, up 8.0
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
        var selectedDuration = 0.0
        
        for index in 0..<numberOfComponents {
            if index == 0 && numberOfComponents == 3{
                selectedDuration += Double(selectedRowInComponent(index)*Int(pow(60.0, Double(numberOfComponents-1-index))))
            } else {
                selectedDuration += Double(selectedRowInComponent(index)%60*Int(pow(60.0, Double(numberOfComponents-1-index))))
            }
        }
        
        return selectedDuration
    }
}

extension DurationPickerView: UIPickerViewDataSource {
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if maximumDuration > 0 {
            return min(3, Int(log(Float(maximumDuration))/log(60.0))+1)
        } else {
            return 1
        }
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let componentUnit = pow(Float(60), Float(numberOfComponentsInPickerView(self)-component-1))
        
        let numberOfRows = Int(min(ceilf(Float(maximumDuration)/componentUnit)+1, 60.0))
        return numberOfRows < 60 ? numberOfRows : 60*500
    }
}

extension DurationPickerView: UIPickerViewDelegate {
    public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        
        let padding = 3
        
        var string = { [unowned self] () -> String in
            if self.numberOfComponentsInPickerView(self) == 3 && component == 0 { //Dont modulo hours
                return String(format:"%d", row)
            } else {
                return String(format:"%d", row%60)
            }
        }()
        
        for _ in 1...padding {
            string += "_"
        }
        
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
        return 50.0
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedDuration > maximumDuration {
            //TODO: Move to max duration
        }
        
        durationDelegate?.pickerView(self, didChangeToValue: selectedDuration)
    }
}

public protocol DurationPickerViewDelegate: class {
    func pickerView(pickerView: DurationPickerView, didChangeToValue value: NSTimeInterval)
}