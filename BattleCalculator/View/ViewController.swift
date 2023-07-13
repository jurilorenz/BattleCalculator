//
//  ViewController.swift
//  MagicCalculator
//
//  Created by Juri Lorenz on 05.07.23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var displayLabelBackground: UIView!
    
    @IBOutlet weak var firstStack: UIStackView!
    
    @IBOutlet weak var secondStack: UIStackView!
    
    @IBOutlet weak var thirdSfack: UIStackView!
    
    @IBOutlet weak var fourthStack: UIStackView!
    
    @IBOutlet weak var fifthStack: UIStackView!
    
    
    
    private var isFinishedTypingNumber: Bool = true
    
    private var player: AVAudioPlayer!
    
    private var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {
                fatalError("Cannot convert display label text to a Double.")
            }
            return number
        }
        set {
            let formattedValue = formatDisplayValue(newValue)
            displayLabel.text = formattedValue
            updateDisplayLabelColor()
        }
    }
    
    private var calculator = CalculatorLogic()
    
    let audioFileNames: [String: String] = [
        "0": "0",
        "1": "1",
        "2": "2",
        "3": "3",
        "4": "4",
        "5": "5",
        "6": "6",
        "7": "7",
        "8": "8",
        "9": "9",
        "AC": "AC",
        "+": "addition",
        "÷": "division",
        "=": "equal",
        "×": "multiplication",
        "%": "percent",
        "+/-": "plus-minus",
        ".": "point",
        "-": "subtraction"
    ]
    
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        
        //What should happen when a non-number button is pressed
        playSound(soundName: sender.currentTitle!)
        
        //Reduces the sender's (the button that got pressed) opacity to half.
        sender.alpha = 0.9
        
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
        playSound(soundName: sender.currentTitle!)
        
        //Reduces the sender's (the button that got pressed) opacity to half.
        sender.alpha = 0.9
        
        
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
    
    func playSound(soundName: String) {
        guard let audioFileName = audioFileNames[soundName],
              let url = Bundle.main.url(forResource: audioFileName, withExtension: "wav") else {
            print("Sound file not found.")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch {
            print("Failed to play sound: \(error)")
        }
    }
    
    private func updateDisplayLabelColor() {
        let colorSequence: [(stack: UIStackView, color: UIColor)] = [
            (firstStack, UIColor(red: 223 / 255.0, green: 46 / 255.0, blue: 56 / 255.0, alpha: 1)),
            (secondStack, UIColor(red: 223 / 255.0, green: 46 / 255.0, blue: 56 / 255.0, alpha: 1)),
            (thirdSfack, UIColor(red: 223 / 255.0, green: 46 / 255.0, blue: 56 / 255.0, alpha: 1)),
            (fourthStack, UIColor(red: 223 / 255.0, green: 46 / 255.0, blue: 56 / 255.0, alpha: 1)),
            (fifthStack, UIColor(red: 223 / 255.0, green: 46 / 255.0, blue: 56 / 255.0, alpha: 1))
        ]
        
        for (index, item) in colorSequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index + 1) * 0.05) {
                self.animateBackgroundColorChange(for: item.stack, color: item.color)
            }
        }
    }
    
    private func animateBackgroundColorChange(for view: UIView, color: UIColor) {
        //Change the display label color to red.
        displayLabel.backgroundColor = UIColor(red: 223 / 255.0, green: 46 / 255.0, blue: 56 / 255.0, alpha: 1)

        //Code should execute after 0.2 second delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //Bring's display's color back to black.
            self.displayLabel.backgroundColor = UIColor(red: 25 / 255.0, green: 26 / 255.0, blue: 25 / 255.0, alpha: 1)
            self.displayLabelBackground.backgroundColor = UIColor(red: 223 / 255.0, green: 46 / 255.0, blue: 56 / 255.0, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.displayLabelBackground.backgroundColor = UIColor(red: 25 / 255.0, green: 26 / 255.0, blue: 25 / 255.0, alpha: 1)
            }
            UIView.animate(withDuration: 0.2, animations: {
                view.backgroundColor = color
            }) { _ in
                UIView.animate(withDuration: 0.05) {
                    view.backgroundColor = UIColor(red: 216 / 255.0, green: 233 / 255.0, blue: 168 / 255.0, alpha: 1)
                }
            }
        }
    }
    
    private func formatDisplayValue(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = value.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 4
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}


