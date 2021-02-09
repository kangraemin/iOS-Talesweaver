//
//  CalculatorViewController.swift
//  Talesweaver
//
//  Created by 강래민 on 2021/01/21.
//

import UIKit

class CalculatorViewController: UIViewController, UITextFieldDelegate {
    
    // View variables
    @IBOutlet weak var conversionButton: UIButton!
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var underTextField: UITextField!
    @IBOutlet weak var underLabel: UILabel!
    @IBOutlet weak var upperLabelTrailingConstants: NSLayoutConstraint!
    @IBOutlet weak var goldHelperLabel: UILabel!
    @IBOutlet weak var moneyHelperLabel: UILabel!
    
    @IBOutlet weak var thoriumLabel: UILabel!
    @IBOutlet weak var platinumLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var seedLabel: UILabel!
    
    var bullion = Bullion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upperTextField.delegate = self
        underTextField.delegate = self
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (textField == self.upperTextField) {
            bullion.calculateUsingGold(inputGold: upperTextField.text!)
            underTextField.text = bullion.getTotalSeedText()
        } else if (textField == self.underTextField) {
            bullion.calculateUsingSeed(inputSeed: underTextField.text!)
            upperTextField.text = bullion.getTotalGoldText()
        }
        print(bullion)
        setBullionNumber()
        goldHelperLabel.text = bullion.getGoldHelperText()
        moneyHelperLabel.text = bullion.getSeedHelperText()
    }
    
    func setBullionNumber() {
        thoriumLabel.text = bullion.getThoriumText()
        platinumLabel.text = bullion.getPlatinumText()
        goldLabel.text = bullion.getGoldText()
        seedLabel.text = bullion.getRemainderSeedText()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
