//
//  File.swift
//  Talesweaver
//
//  Created by 강래민 on 2021/02/10.
//

import Foundation

struct Bullion {
    let moneyUnit = ["", "만", "억", "조", "경", "해", "자"]
    let pivotGoldSeed: Int64 = 44000000
    let pivotPlatinumSeed: Int64
    var pivotThoriumSeed: Int64
    var totalGold: Int64 = 0
    var totalSeed: Int64 = 0
    var thorium: Int64 = 0
    var platinum: Int64 = 0
    var gold: Int64 = 0
    var remainderSeed: Int64 = 0
    
    // Constants
    let EMPTY_RESULT: Int64 = 0
    let INVALID_VALUE: Int64 = -1
    let INT64_MAX_DIGIT = (Int) (floor(log10(Double(Int64.max))) + 1)
    
    enum HelperTextType: String {
        case gold = "괴", seed = "시드"
    }
    
    enum InputType {
        case GOLD, SEED
    }
    
    init() {
        pivotPlatinumSeed = pivotGoldSeed * 5
        pivotThoriumSeed = pivotGoldSeed * 10
    }
    
    
    func getTotalGoldText() -> String {
        return transformResultToString(resultNumber: totalGold, isBullionCase: false)
    }
    func getTotalSeedText() -> String {
        return transformResultToString(resultNumber: totalSeed, isBullionCase: false)
    }
    func getThoriumText() -> String {
        return transformResultToString(resultNumber: thorium, isBullionCase: true)
    }
    func getPlatinumText() -> String {
        return transformResultToString(resultNumber: platinum, isBullionCase: true)
    }
    func getGoldText() -> String {
        return transformResultToString(resultNumber: gold, isBullionCase: true)
    }
    func getRemainderSeedText() -> String {
        return transformResultToString(resultNumber: remainderSeed, isBullionCase: true)
    }
    
    func getGoldHelperText() -> String {
        return transformToHelperText(inputNumber: totalGold, helperTextType: HelperTextType.gold)
    }
    
    func getSeedHelperText() -> String {
        return transformToHelperText(inputNumber: totalSeed, helperTextType: HelperTextType.seed)
    }
    
    mutating func calculateUsingGold(inputGold: String) {
        let inputNumberOfGold = getNumberFromText(text: inputGold, inputType: InputType.GOLD)
        if (inputNumberOfGold == EMPTY_RESULT || inputNumberOfGold == INVALID_VALUE) {
            self.thorium = inputNumberOfGold
            self.platinum = inputNumberOfGold
            self.gold = inputNumberOfGold
            self.remainderSeed = inputNumberOfGold
            self.totalSeed = inputNumberOfGold
            self.totalGold = inputNumberOfGold
            return
        }
        self.totalGold = inputNumberOfGold
        self.totalSeed = calculateGoldToSeed(gold: inputNumberOfGold)
        calculateSeedToBullion(inputSeed: self.totalSeed)
    }
    
    mutating func calculateUsingSeed(inputSeed: String) {
        let inputNumberOfSeed = getNumberFromText(text: inputSeed, inputType: InputType.SEED)
        if (inputNumberOfSeed == EMPTY_RESULT || inputNumberOfSeed == INVALID_VALUE) {
            self.thorium = inputNumberOfSeed
            self.platinum = inputNumberOfSeed
            self.gold = inputNumberOfSeed
            self.remainderSeed = inputNumberOfSeed
            self.totalGold = inputNumberOfSeed
            self.totalSeed = inputNumberOfSeed
            return
        }
        self.totalSeed = inputNumberOfSeed
        self.totalGold = calculateSeedToGold(seed: inputNumberOfSeed)
        calculateSeedToBullion(inputSeed: self.totalSeed)
    }
    
    mutating func calculateSeedToBullion(inputSeed: Int64) {
        var remainderSeed = inputSeed
        self.thorium = inputSeed / pivotThoriumSeed
        remainderSeed = remainderSeed - thorium * pivotThoriumSeed
        self.platinum = remainderSeed / pivotPlatinumSeed
        remainderSeed = remainderSeed - platinum * pivotPlatinumSeed
        self.gold = remainderSeed / pivotGoldSeed
        remainderSeed = remainderSeed - gold * pivotGoldSeed
        self.remainderSeed = remainderSeed
    }
    
    func calculateGoldToSeed(gold: Int64) -> Int64 {
        return pivotGoldSeed * gold
    }
    
    func calculateSeedToGold(seed: Int64) -> Int64 {
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
    
    func getNumberFromText(text: String?, inputType: InputType) -> Int64 {
        if let safeText = text {
            if (safeText.isEmpty) {
                return EMPTY_RESULT
            }
            let resultValue = Int64(safeText) ?? INVALID_VALUE
            if (resultValue < 0) {
                return INVALID_VALUE
            }
            if (inputType == InputType.GOLD) {
                if (resultValue >= Int64.max / pivotGoldSeed) {
                    return INVALID_VALUE
                }
            } else if (inputType == InputType.SEED) {
                if (resultValue >= Int64.max) {
                    return INVALID_VALUE
                }
            }
            return resultValue
        } else {
            return EMPTY_RESULT
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
                let tempArray = aryChar[startIndex..<endIndex]
                var needToRemoveCount = 0
                for i in 0..<tempArray.count {
                    if (tempArray[startIndex + i] == "0") {
                        needToRemoveCount += 1
                    } else {
                        break
                    }
                }
                if (needToRemoveCount != endIndex - startIndex) {
                    resultString.append(contentsOf: tempArray[(startIndex + needToRemoveCount)..<endIndex])
                    resultString.append(moneyUnit[maxInputNumberDigit-i])
                }
            } else {
                let startIndex = resNumberFirstDigit + (i-1)*4
                let endIndex = resNumberFirstDigit + (i-1)*4 + 4
                let tempArray = aryChar[startIndex..<endIndex]
                var needToRemoveCount = 0
                for i in 0..<tempArray.count {
                    if (tempArray[startIndex + i] == "0") {
                        needToRemoveCount += 1
                    } else {
                        break
                    }
                }
                if (needToRemoveCount != endIndex - startIndex) {
                    resultString.append(contentsOf: tempArray[(startIndex + needToRemoveCount)..<endIndex])
                    resultString.append(moneyUnit[maxInputNumberDigit-i])
                }
            }
        }
        resultString.append(helperTextType.rawValue)
        return resultString
    }
}
