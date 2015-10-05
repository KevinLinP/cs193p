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
        addToEntryList(digit);
        
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
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        addToEntryList(operation)
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let result = brain.performOperation(operation) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
//    @IBAction func clear() {
//        inputList.text = ""
//        display.text = "0"
//        userIsInTheMiddleOfTypingANumber = false
//        operandStack.removeAll()
//        print("operandStack = \(operandStack)")
//    }
    
    func addToEntryList(entry: String) {
        inputList.text! += entry + " ";
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}