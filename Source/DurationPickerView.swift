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

open class DurationPickerView: UIPickerView {
    open  var  maximumDuration: TimeInterval = 0.0 {
        didSet {
            setNeedsDisplay()

            reloadAllComponents()
            
            (1..<numberOfComponents).forEach { index in
                selectRow(60*reelRepititions/2, inComponent: index, animated: false)
            }
        }
    }
    
    weak open var durationDelegate: DurationPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    fileprivate func setUp() {
        dataSource = self
        delegate = self
    }
    
    open override func draw(_ rect: CGRect) {
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let firstLabelTranslation = CGAffineTransform(translationX: -CGFloat(numberOfComponents)/2.0*componentWidth+30.0, y: -8.0) // Move left half of width - 30.0, up 8.0
        let firstLabelLeft = center.applying(firstLabelTranslation)
        
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
            
            let labelLeft = firstLabelLeft.applying(CGAffineTransform(translationX: 55.0*CGFloat(index), y: 0.0))
            
            labelText?.draw(at: labelLeft, withAttributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold),
                ])
        }
    }
    
    internal var selectedDuration: TimeInterval {
        return (0..<numberOfComponents).reduce(TimeInterval(0.0)) { (acc, index) -> TimeInterval in
            let componentPlaceValue = placeValueForComponent(index)
            var row = selectedRow(inComponent: index)
            
            if componentPlaceValue != 60*60 {
                row %= 60
            }
            return acc + TimeInterval(row*componentPlaceValue)
        }
    }
}

extension DurationPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return maximumDuration > 0 ?
            min(3, Int(log(Float(maximumDuration))/log(60.0))+1) : 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let componentPlaceValue = placeValueForComponent(component)
        
        let numberOfRows = min(Int(maximumDuration)/componentPlaceValue+1, 60)
        return numberOfRows == 60 && component > 0 ? 60*reelRepititions : numberOfRows
    }
}

extension DurationPickerView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        
        //Pad string with invisible _, spaces or transform on label doesn't work
        let paddingLength = 3
        
        let rowText = (self.numberOfComponents == 3 && component == 0 ? // Don't modulo hours
            String(format:"%d", row) : String(format:"%d", row%60))
        
        let paddedRowText = rowText + String(repeating: String(("_" as Character)), count: paddingLength)
        
        let attributedString = NSMutableAttributedString(string: paddedRowText)
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear],
                                       range: NSMakeRange(paddedRowText.characters.count-paddingLength, paddingLength))
        
        label.attributedText = attributedString
        label.textAlignment = .right
        
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return componentWidth
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
    
    fileprivate func placeValueForComponent(_ component: Int) -> Int {
        return Int(pow(Float(60), Float(numberOfComponents-component-1)))
    }
}

@objc public protocol DurationPickerViewDelegate: class {
    func pickerView(_ pickerView: DurationPickerView, didChangeToValue value: TimeInterval)
}
