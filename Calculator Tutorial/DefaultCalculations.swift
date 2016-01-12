//
//  DefaultCalculations.swift
//  Calculator
//
//  Created by Cal on 9/11/15.
//  Copyright (c) 2015 Georgia Tech's iOS Club. All rights reserved.
//

import Foundation

//MARK: - Default Implementation of the Calculation Protocol

class DefaultCalculations : CalculationDelegate {
    
    var previousExpressions: [(expression: String, result: String)] = []
    var currentOperator: Operator?
    
    var leftNumber: Double?
    var rightNumber: Double?
    var resultNumber: Double {
        if let leftNumber = leftNumber {
            return rightNumber ?? leftNumber
        }
        return leftNumber ?? Double(previousExpressions.last?.result ?? "a") ?? 0.0
    }
    
    var expressionString: String {
        if let left = leftNumber?.roundedString {
            if let operatorChar = currentOperator?.character {
                let right = rightNumber?.roundedString ?? "0"
                return "\(left) \(operatorChar) \(right) = "
            }
            return "\(left) = "
        }
        return "0 = "
    }
    
    func handleInput(input: Int) {
        
        //fixes equals bug where it would just append to the end of the previous answer
        if expressionString == "" {
            leftNumber = nil
        }
        
        //update the left number until the operator has been set
        let useLeft = (currentOperator == nil)
        
        //update numbers
        let optionalNumber = useLeft ? leftNumber : rightNumber
        var newNumber = optionalNumber ?? 0.0
        newNumber = (newNumber * 10) + Double(input)
        
        if useLeft { leftNumber = newNumber }
        else { rightNumber = newNumber }
    }
    
    func setOperator(newOperator: Operator) {
        if leftNumber == nil {
            leftNumber = Double(previousExpressions.last?.result ?? "a") ?? 0.0
        }
        
        //if there's a number on the Right,
        if rightNumber != nil {
            clearInputAndSave(true)
            leftNumber = resultNumber
        }
        
        currentOperator = newOperator
    }
    
    func clearInputAndSave(save: Bool) {
        
        if !save {
            previousExpressions.append((expression: "cleared", result: ""))
        }
        
        let result = currentOperator?.operate(leftNumber ?? 0.0, rightNumber ?? 0.0)
        
        if leftNumber != nil || rightNumber != nil || currentOperator != nil {
            if let result = result {
                previousExpressions.append((expression: expressionString, result: "\(result)"))
            }
        }
        
        leftNumber = nil
        rightNumber = nil
        currentOperator = nil
    }
    
}

//MARK: - Default Implementation of the Operator protocol

struct DefaultOperator : Operator {
    
    var character: String
    var operate: (Double, Double) -> Double
    
    init(forCharacter character: String, withFunction operate: (Double, Double) -> Double) {
        self.character = character
        self.operate = operate
    }
    
}

//MARK: - Double Extension, adds .roundedString variable

extension Double {
    
    var roundedString: String {
        let rounded = round(self * 100) / 100
        let string = "\(rounded)"
        return string.hasSuffix(".0") ? "\(Int(self))" : string
    }
    
}