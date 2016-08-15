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

	var brain = CalculatorBrain()
	
	@IBOutlet weak var display: UILabel!
	
	private var userIsInTheMiddleOfTypingANumber = false
	
	@IBOutlet weak var calculatorHistory: UILabel!
	
	// local display computed variable used to when displayValue is needed as a double
	private var displayValue: Double {
		get {
			return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
		}
		set {
			display.text = "\(newValue)"
			userIsInTheMiddleOfTypingANumber = false
		}
	}
	
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
		if userIsInTheMiddleOfTypingANumber {
			enter()
		}
		if let operation = sender.currentTitle {
			if let result = brain.performOperation(operation) {
				displayValue = result
				calculatorHistory.text = calculatorHistory.text! + ", \(operation)"
			} else {
				displayValue = 0
			}
		}
	}
	
	@IBAction func enter() {
		userIsInTheMiddleOfTypingANumber = false
		if let result = brain.pushOperand(displayValue) {
			displayValue = result
			if calculatorHistory.text!.containsString("Calculator History") {
				calculatorHistory.text = "\(result)"
			} else {
				calculatorHistory.text = calculatorHistory.text! + ", \(result)"
			}
		} else {
			displayValue = 0
		}
	}
	
	@IBAction func clear() {
		display.text = "0"
		calculatorHistory.text = "Calculator History"
	}
	
	@IBAction func floatingPointDecimal() {
		if userIsInTheMiddleOfTypingANumber && !(display.text?.containsString("."))! {
			display.text = display.text! + "."
		}
	}
}











