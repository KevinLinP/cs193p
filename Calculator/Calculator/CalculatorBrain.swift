//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Kevin Lin on 10/4/15.
//  Copyright © 2015 Kevin Lin. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case SymbolOperand(String, Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            switch self {
            case .Operand(let operand): return "\(operand)"
            case .SymbolOperand(let symbol, _): return symbol
            case .UnaryOperation(let operation, _): return operation
            case .BinaryOperation(let operation, _): return operation
            }
        }
    }
    
    private var opStack = [Op]()
    
    var description: String {
        func stringFromStack(stack: [Op]) -> (desc: String, remainingStack: [Op]) {
            var remainingStack = stack
            var desc = "?"
            
            if !stack.isEmpty {
                let op = remainingStack.removeLast()
                
                switch op {
                case .Operand(let num):
                    desc = num.description
                case .SymbolOperand(let symbol, _):
                    desc = symbol
                case .UnaryOperation(let symbol, _):
                    let recurseResult = stringFromStack(remainingStack)
                    desc = "\(symbol)(\(recurseResult.desc))"
                    remainingStack = recurseResult.remainingStack
                case .BinaryOperation(let symbol, _):
                    let firstRecurse = stringFromStack(remainingStack)
                    let secondRecurse = stringFromStack(firstRecurse.remainingStack)
                    desc = "(\(secondRecurse.desc) \(symbol) \(firstRecurse.desc))"
                    remainingStack = secondRecurse.remainingStack
                }
            }
            
            return (desc, remainingStack)
        }
        
        var remainingStack = opStack
        var expressions = [String]()
        
        while !remainingStack.isEmpty {
            let result = stringFromStack(remainingStack)
            expressions.append(result.desc)
            remainingStack = result.remainingStack
        }
        
        return expressions.joinWithSeparator(", ")
    }
    
    var variableValues = [String: Double]()
    
    private let knownSymbols = [
        "π": Op.SymbolOperand("π", M_PI)
    ]
    
    private let knownOps = [
        "×": Op.BinaryOperation("×", *),
        "÷": Op.BinaryOperation("÷") { $1 / $0 },
        "+": Op.BinaryOperation("+", +),
        "−": Op.BinaryOperation("−") { $1 - $0 },
        "sin": Op.UnaryOperation("sin", sin),
        "cos": Op.UnaryOperation("cos", cos),
        "√": Op.UnaryOperation("√", sqrt)
    ]
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        
        print("\(opStack) = \(result?.description ?? "ERR") with \(remainder) left over")
        
        return result
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .SymbolOperand(_, let value):
                return (value, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        
        return evaluate()
    }

    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        if let symbol = knownSymbols[symbol] {
            opStack.append(symbol)
        }
        
        return evaluate()
    }
    
    func clear() {
        opStack = []
    }
}