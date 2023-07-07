//
//  ViewController.swift
//  MagicCalculator
//
//  Created by Juri Lorenz on 05.07.23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    private var isFinishedTypingNumber: Bool = true
    
    private var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {
                fatalError("Cannot convert display label text to a Double.")
            }
            return number
        }
        set {
            displayLabel.text = String(newValue)
            
            //Reduces the sender's (the button that got pressed) opacity to half.
            displayLabel.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            
            //Code should execute after 0.2 second delay.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                //Bring's sender's opacity back up to fully opaque.
                self.displayLabel.backgroundColor = UIColor(red: 25 / 255.0, green: 26 / 255.0, blue: 25 / 255.0, alpha: 1)
            }
        }
    }
    
    private var calculator = CalculatorLogic()
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        
        //What should happen when a non-number button is pressed
        
        //Reduces the sender's (the button that got pressed) opacity to half.
        sender.alpha = 0.7
        
        //Code should execute after 0.2 second delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //Bring's sender's opacity back up to fully opaque.
            sender.alpha = 1
        }
        
        isFinishedTypingNumber = true
        
        calculator.setNumber(displayValue)
        
        if let calcMethod = sender.currentTitle {
 
            if let result = calculator.calculate(symbol: calcMethod) {
                displayValue = result
            }
        }
    }

    

    @IBAction func numButtonPressed(_ sender: UIButton) {
        
        //What should happen when a number is entered into the keypad
        
        //Reduces the sender's (the button that got pressed) opacity to half.
        sender.alpha = 0.7
        
        
        //Code should execute after 0.2 second delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //Bring's sender's opacity back up to fully opaque.
            sender.alpha = 1
        }
        
        if let numValue = sender.currentTitle {
            
            if isFinishedTypingNumber {
                displayLabel.text = numValue
                isFinishedTypingNumber = false
            } else {
                
                if numValue == "." {
                    
                    let isInt = floor(displayValue) == displayValue
                    
                    if !isInt {
                        return
                    }
                }
                displayLabel.text = displayLabel.text! + numValue
            }
        }
    }
}



