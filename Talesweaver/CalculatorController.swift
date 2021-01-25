//
//  CalculatorController.swift
//  Talesweaver
//
//  Created by 강래민 on 2021/01/21.
//

import UIKit

class CalculatorController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conversionButton: UIButton!
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var underTextField: UITextField!
    @IBOutlet weak var underLabel: UILabel!
    @IBOutlet weak var upperLabelTrailingConstants: NSLayoutConstraint!
    
    private let pivotGoldSeed = 44000000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upperTextField.delegate = self
        underTextField.delegate = self
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (textField == self.upperTextField) {
            underTextField.text = String(calculateGoldToSeed(gold: Int(textField.text!)!))
        } else if (textField == self.underTextField) {
            upperTextField.text = String(calculateSeedToGold(seed: Int(textField.text!)!))
        }
    }

    func calculateGoldToSeed(gold: Int) -> Int {
        return pivotGoldSeed * gold
    }
    
    func calculateSeedToGold(seed: Int) -> Int {
        return seed / pivotGoldSeed
    }
}
