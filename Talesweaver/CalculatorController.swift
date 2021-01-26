//
//  CalculatorController.swift
//  Talesweaver
//
//  Created by 강래민 on 2021/01/21.
//

import UIKit

class CalculatorController: UIViewController, UITextFieldDelegate {

    // View variables
    @IBOutlet weak var conversionButton: UIButton!
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var underTextField: UITextField!
    @IBOutlet weak var underLabel: UILabel!
    @IBOutlet weak var upperLabelTrailingConstants: NSLayoutConstraint!

    // Constants
    private let pivotGoldSeed: Int64 = 44000000
    private let EMPTY_RESULT: Int64 = 0
    private let INVALID_VALUE: Int64 = -1
    private let INT64_MAX_DIGIT = (Int) (floor(log10(Double(Int64.max))) + 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upperTextField.delegate = self
        underTextField.delegate = self
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (textField == self.upperTextField) {
            underTextField.text = transformResultToString(resultNumber: calculateGoldToSeed(gold: getNumberFromText(text: upperTextField.text)))
        } else if (textField == self.underTextField) {
            upperTextField.text = transformResultToString(resultNumber: calculateSeedToGold(seed: getNumberFromText(text: underTextField.text)))
        }
    }
    
    func getNumberFromText(text: String?) -> Int64 {
        if let safeText = text {
            if (safeText.isEmpty) {
                return EMPTY_RESULT
            }
            let resultValue = Int64(safeText) ?? INVALID_VALUE
            if (resultValue < 0) {
                return INVALID_VALUE
            }
            return resultValue
        } else {
            return EMPTY_RESULT
        }
    }

    func calculateGoldToSeed(gold: Int64) -> Int64 {
        if (gold == INVALID_VALUE || gold == EMPTY_RESULT) {
            return gold
        }
        if (gold >= Int64.max / pivotGoldSeed) {
            return INVALID_VALUE
        }
        return pivotGoldSeed * gold
    }
    
    func calculateSeedToGold(seed: Int64) -> Int64 {
        if (seed == INVALID_VALUE || seed == EMPTY_RESULT) {
            return seed
        }
        if (seed >= Int64.max) {
            return INVALID_VALUE
        }
        return seed / pivotGoldSeed
    }
    
    func transformResultToString(resultNumber: Int64) -> String {
        if (resultNumber == EMPTY_RESULT) {
            return ""
        } else if (resultNumber == INVALID_VALUE) {
            return "말이됨 ?????"
        }
        return String(resultNumber)
    }
}
