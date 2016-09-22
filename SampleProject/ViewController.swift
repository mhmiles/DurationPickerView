//
//  ViewController.swift
//  SampleProject
//
//  Created by Miles Hollingsworth on 5/28/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import UIKit
import DurationPickerView

class ViewController: UIViewController {
    @IBOutlet weak var selectedDurationLabel: UILabel!
    @IBOutlet weak var durationPickerView: DurationPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        durationPickerView.durationDelegate = self
        durationPickerView.maximumDuration = 3600*20.123
    }
}

extension ViewController: DurationPickerViewDelegate {
    func pickerView(_ pickerView: DurationPickerView, didChangeToValue value: TimeInterval) {
        selectedDurationLabel.text = String(Int(value))
    }
}
