//
//  ViewController.swift
//  Calcu
//
//  Created by 灿 崔 on 26/09/2016.
//  Copyright © 2016 Can. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var brain = CalculatorBrain()
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping: Bool = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        print("tough \(digit)")
        if userIsInTheMiddleOfTyping{
            let digitCurrentlyInDisplay = display!.text!
            display.text = digitCurrentlyInDisplay + digit
        }else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        
        set{
            display.text = String(newValue)
        }
    }
    
    
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        
        if let mathematicalOperation = sender.currentTitle{
            brain.performOperation(mathematicalOperation)
        }
        displayValue = brain.result
    }
}

