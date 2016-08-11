//
//  ViewController.swift
//  Calculator (iOS 8)
//
//  Created by Nolan Lapham on 8/11/16.
//  Copyright © 2016 Nolan Lapham. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

	@IBOutlet weak var display: UILabel!
	
	// local display computed variable used to convert to double
	var displayValue: Double {
		get {
			return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
		}
		set {
			display.text = "\(newValue)"
			userIsInTheMiddleOfTypingANumber = false
		}
	}
	
	var userIsInTheMiddleOfTypingANumber = false
	
	@IBAction func appendDigit(sender: UIButton)
	{
		let digit = sender.currentTitle!
		
		if userIsInTheMiddleOfTypingANumber {
			display.text = display.text! + digit
		} else {
			display.text = digit
			userIsInTheMiddleOfTypingANumber = true
		}
	}
	
	@IBAction func operate(sender: UIButton) {
		let operation = sender.currentTitle!
		if userIsInTheMiddleOfTypingANumber {
			enter()
		}
		switch operation {
		case "×": performOperation { $0 * $1 }
		case "÷": performOperation { $1 / $0 }
		case "+": performOperation { $0 + $1 }
		case "−": performOperation { $1 - $0 }
		case "√": performOperation { sqrt($0) }
		default: break
		}
	}
	
	private func performOperation(operations: Double -> Double) {
		if operandStack.count >= 1 {
			displayValue = operations(operandStack.removeLast())
			enter()
		}
	}
	
	private func performOperation(operation: (Double, Double) -> Double) {
		if operandStack.count >= 2 {
			displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
			enter()
		}
	}


	var operandStack = Array<Double>()
	
	@IBAction func enter() {
		userIsInTheMiddleOfTypingANumber = false
		operandStack.append(displayValue)
		print("operandStack = \(operandStack)")
	}
}











