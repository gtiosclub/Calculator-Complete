//
//  CalculationDelegate.swift
//  Calculator
//
//  Created by Cal on 9/11/15.
//  Copyright (c) 2015 Georgia Tech's iOS Club. All rights reserved.
//

import Foundation

protocol CalculationDelegate {
    
    var previousExpressions: [(expression: String, result: String)] { get set }
    var currentOperator: Operator? { get set }
    
    var leftNumber: Double? { get set }
    var rightNumber: Double? { get set }
    var resultNumber: Double { get }
    
    var expressionString: String { get }
    
    func handleInput(number: Int)
    func setOperator(newOperator: Operator)
    func clearInputAndSave(save: Bool)
    
}

protocol Operator {
    
    var character: String { get }
    var operate: (Double, Double) -> Double { get }
    init(forCharacter character: String, withFunction: (Double, Double) -> Double)
    
}