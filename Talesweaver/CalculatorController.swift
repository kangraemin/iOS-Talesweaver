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
    
    @IBOutlet weak var thoriumLabel: UILabel!
    @IBOutlet weak var platinumLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var seedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upperTextField.delegate = self
        underTextField.delegate = self
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (textField == self.upperTextField) {
            let inputNumber = getNumberFromText(text: upperTextField.text)
            underTextField.text = transformResultToString(resultNumber: calculateGoldToSeed(gold: inputNumber), isBullionCase: false)
            setBullionNumber(inputSeed: getNumberFromText(text: underTextField.text))
        } else if (textField == self.underTextField) {
            let inputNumber = getNumberFromText(text: underTextField.text)
            upperTextField.text = transformResultToString(resultNumber: calculateSeedToGold(seed: inputNumber), isBullionCase: false)
            setBullionNumber(inputSeed: inputNumber)
        }
    }
    
    func setBullionNumber(inputSeed: Int64) {
        if (inputSeed == INVALID_VALUE || inputSeed == EMPTY_RESULT) {
            thoriumLabel.text = transformResultToString(resultNumber: inputSeed, isBullionCase: true)
            platinumLabel.text = transformResultToString(resultNumber: inputSeed, isBullionCase: true)
            goldLabel.text = transformResultToString(resultNumber: inputSeed, isBullionCase: true)
            seedLabel.text = transformResultToString(resultNumber: inputSeed, isBullionCase: true)
        } else {
            let bullion = Bullion(inputSeed: inputSeed)
            thoriumLabel.text = transformResultToString(resultNumber: bullion.thorium, isBullionCase: true)
            platinumLabel.text = transformResultToString(resultNumber: bullion.platinum, isBullionCase: true)
            goldLabel.text = transformResultToString(resultNumber: bullion.gold, isBullionCase: true)
            seedLabel.text = transformResultToString(resultNumber: bullion.remainderSeed, isBullionCase: true)
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
    
    func transformResultToString(resultNumber: Int64, isBullionCase: Bool) -> String {
        if (resultNumber == EMPTY_RESULT) {
            if (isBullionCase) {
                return "0"
            } else {
                return ""
            }
        } else if (resultNumber == INVALID_VALUE) {
            return "말이됨 ?????"
        }
        return String(resultNumber)
    }
}

struct Bullion {
    let pivotGoldSeed: Int64 = 44000000
    var pivotPlatinumSeed: Int64
    var pivotThoriumSeed: Int64
    var thorium: Int64
    var platinum: Int64
    var gold: Int64
    var remainderSeed: Int64
    
    init(inputSeed: Int64) {
        var remainderSeed = inputSeed
        pivotPlatinumSeed = pivotGoldSeed * 5
        pivotThoriumSeed = pivotGoldSeed * 10
        self.thorium = inputSeed / pivotThoriumSeed
        remainderSeed = remainderSeed - thorium * pivotThoriumSeed
        self.platinum = remainderSeed / pivotPlatinumSeed
        remainderSeed = remainderSeed - platinum * pivotPlatinumSeed
        self.gold = remainderSeed / pivotGoldSeed
        self.remainderSeed = remainderSeed
        print(self)
    }
}
