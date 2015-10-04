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
    var operandStack = Array<Double>()
    
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
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        addToEntryList(operation)
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }

        switch operation {
            case "×": performOperation(*)
            case "÷": performOperation(/)
            case "+": performOperation(+)
            case "−": performOperation(-)
            case "sin": performSingleOperation(sin)
            case "cos": performSingleOperation(cos)
            case "π":
                displayValue = M_PI
                enter()
            case "√": performSingleOperation(sqrt)
            default: break
        }
    }
    
    func addToEntryList(entry: String) {
        inputList.text! += entry + " ";
    }
        
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performSingleOperation(operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
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