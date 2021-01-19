//
//  ViewController.swift
//  Talesweaver
//
//  Created by 강래민 on 2021/01/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calculatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveToCalculatorViewController(_:)))
        self.calculatorView.addGestureRecognizer(gesture)
    }
    
    @objc func moveToCalculatorViewController(_ sender: UIGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "calculatorViewController")
        present(vc, animated: true)
    }
}

