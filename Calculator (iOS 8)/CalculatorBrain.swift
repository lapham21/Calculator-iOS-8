//
//  CalculatorBrain.swift
//  Calculator (iOS 8)
//
//  Created by Nolan Lapham on 8/12/16.
//  Copyright © 2016 Nolan Lapham. All rights reserved.
//

import Foundation

class CalculatorBrain
{
	private enum Op: CustomStringConvertible {
		case Operand(Double)
		case Constant(String, () -> Double)
		case UnaryOperation(String, Double -> Double)
		case BinaryOperation(String, (Double, Double) -> Double)
		
		var description: String {
			switch self {
			case .Operand(let operand):
				return "\(operand)"
			case .Constant(let symbol, _):
				return symbol
			case .UnaryOperation(let symbol, _):
				return symbol
			case .BinaryOperation(let symbol, _):
				return symbol
			}
		}
	}
	
	private var opStack = [Op]()
	
	private var knownOps = [String:Op]()
	
	init() {
		func learnOp(op: Op) {
			knownOps[op.description] = op
		}
		learnOp(Op.BinaryOperation("×", *))
		learnOp(Op.BinaryOperation("÷") { $1 / $0 })
		learnOp(Op.BinaryOperation("+", +))
		learnOp(Op.BinaryOperation("−") { $1 - $0 })
		learnOp(Op.Constant("π") { M_PI })
		learnOp(Op.UnaryOperation("sin", sin))
		learnOp(Op.UnaryOperation("cos", cos))
		learnOp(Op.UnaryOperation("√", sqrt))
		learnOp(Op.UnaryOperation("±") { -$0 })
	}
	
	private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
	{
		if !ops.isEmpty {
			var remainingOps = ops
			let op = remainingOps.removeLast()
			switch op {
			case .Operand(let operand):
				return (operand, remainingOps)
			case .Constant(_, let constant):
				return (constant(), remainingOps)
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
		return(nil, ops)
	}
	
	func evaluate() -> Double? {
		let (result, remainder) = evaluate(opStack)
		print("\(opStack) = \(result) with \(remainder) left over")
		return result
	}
	
	func pushOperand(operand: Double) -> Double? {
		opStack.append(Op.Operand(operand))
		return evaluate()
	}
	
	func performOperation(symbol: String) -> Double? {
		if let operation = knownOps[symbol] {
			opStack.append(operation)
		}
		return evaluate()
	}

	func clearStack() {
		opStack.removeAll()
	}
}



