//
//  CalculatorBrain.swift
//  Calcu
//
//  Created by 灿 崔 on 27/09/2016.
//  Copyright © 2016 Can. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double){
        internalProgram.append(operand)
        accumulator = operand
    }
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Reset
        case Equals
    }
    
    var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "=" : Operation.Equals,
        "+" : Operation.BinaryOperation(+),
        "−" : Operation.BinaryOperation(-),
        "×" : Operation.BinaryOperation(*),
        "÷" : Operation.BinaryOperation(/),
        "AC" : Operation.Reset
        
    ]
    
    
    func performOperation(symbol: String){
        internalProgram.append(symbol)
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = pendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals :
                executePendingBinaryOperation()
            case .Reset:
                pending = nil
                accumulator = 0
                
            }
        }
        
    }
    private func executePendingBinaryOperation(){
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending:pendingBinaryOperationInfo?
    
    struct pendingBinaryOperationInfo {
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
        
    }
    
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList{
        get{
            return internalProgram
        }
        
        set{
            clear()
            if let arrayofOps = newValue as? [AnyObject]{
                for op in arrayofOps{
                    if let operand = op as? Double{
                        setOperand(operand)
                    }else if let operation = op as? String{
                        performOperation(operation)
                    }
                    
                }
            }
            
        }
    }
    
    func clear(){
        accumulator = 0
        pending = nil
        internalProgram.removeAll()
    }
    
    
    var result: Double{
        get {
            return accumulator
        }
    }
    
}