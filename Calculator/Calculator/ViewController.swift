//
//  ViewController.swift
//  Calculator
//
//  Created by Kevin Lin on 9/30/15.
//  Copyright © 2015 Kevin Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var inputList: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." && display.text!.containsString(".") {
            return
        }
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        
        if let value = displayValue {
            displayValue = brain.pushOperand(value)
        }
        
        inputList.text = brain.description
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let result = brain.performOperation(operation) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
        inputList.text = brain.description
    }
    
    @IBAction func clear() {
        inputList.text = ""
        display.text = "0"
        userIsInTheMiddleOfTypingANumber = false
        brain.clear()
    }
    
    var displayValue: Double? {
        get {
            if display.text!.isEmpty {
                return nil
            } else {
               return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            }
        }
        set {
            userIsInTheMiddleOfTypingANumber = false
            if let num = newValue {
                display.text = "\(num)"
            } else {
                display.text = ""
            }
        }
    }
    
    @IBAction func storeVariable() {
        brain.variableValues["M"] = displayValue
    }
    
    @IBAction func callVariable() {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        displayValue = brain.pushOperand("M")
        inputList.text = brain.description
    }
}