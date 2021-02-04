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
    @IBOutlet weak var goldHelperLabel: UILabel!
    @IBOutlet weak var moneyHelperLabel: UILabel!
    
    // Constants
    private let pivotGoldSeed: Int64 = 44000000
    private let EMPTY_RESULT: Int64 = 0
    private let INVALID_VALUE: Int64 = -1
    private let INT64_MAX_DIGIT = (Int) (floor(log10(Double(Int64.max))) + 1)
    
    @IBOutlet weak var thoriumLabel: UILabel!
    @IBOutlet weak var platinumLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var seedLabel: UILabel!
    
    let moneyUnit = ["", "만", "억", "조", "경", "해", "자"]
    
    enum HelperTextType: String {
        case gold = "괴", seed = "시드"
    }
    
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
            goldHelperLabel.text = transformToHelperText(inputNumber: inputNumber, helperTextType: .gold)
            moneyHelperLabel.text = transformToHelperText(inputNumber: getNumberFromText(text: underTextField.text), helperTextType: .seed )
        } else if (textField == self.underTextField) {
            let inputNumber = getNumberFromText(text: underTextField.text)
            upperTextField.text = transformResultToString(resultNumber: calculateSeedToGold(seed: inputNumber), isBullionCase: false)
            setBullionNumber(inputSeed: inputNumber)
            goldHelperLabel.text = transformToHelperText(inputNumber: getNumberFromText(text: upperTextField.text), helperTextType: .gold)
            moneyHelperLabel.text = transformToHelperText(inputNumber: inputNumber, helperTextType: .seed)
        }
    }
    
    func transformToHelperText(inputNumber: Int64, helperTextType: HelperTextType) -> String {
        if (inputNumber == INVALID_VALUE || inputNumber == EMPTY_RESULT) {
            return ""
        }
        let inputNumberText = String(inputNumber)
        let maxInputNumberDigit = (inputNumberText.count-1) / 4
        let resNumberFirstDigit = inputNumberText.count - maxInputNumberDigit * 4
        let aryChar = Array(inputNumberText)
        var resultString = ""
        for i in 0...maxInputNumberDigit {
            if (i == 0) {
                let startIndex = 0
                let endIndex = resNumberFirstDigit
                resultString.append(contentsOf: aryChar[startIndex..<endIndex])
                resultString.append(moneyUnit[maxInputNumberDigit-i])
            } else if (i == maxInputNumberDigit) {
                let startIndex = (i-1)*4 + resNumberFirstDigit
                let endIndex = inputNumberText.count
                resultString.append(contentsOf: aryChar[startIndex..<endIndex])
                resultString.append(moneyUnit[maxInputNumberDigit-i])
            } else {
                let startIndex = resNumberFirstDigit + (i-1)*4
                let endIndex = resNumberFirstDigit + (i-1)*4 + 4
                resultString.append(contentsOf: aryChar[startIndex..<endIndex])
                resultString.append(moneyUnit[maxInputNumberDigit-i])
            }
        }
        resultString.append(helperTextType.rawValue)
        return resultString
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

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    }
}
