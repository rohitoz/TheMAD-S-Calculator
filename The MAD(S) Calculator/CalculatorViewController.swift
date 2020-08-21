//
//  CalculatorViewController.swift
//  The MAD(S) Calculator
//
//  Created by Geekyworks on 20/08/20.
//  Copyright © 2020 Rohit Nikam. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CalculatorViewController: UIViewController {

    @IBOutlet weak var equationLabel: UILabel!
    @IBOutlet weak var ansLabel: UILabel!
    @IBOutlet weak var equationText: UITextField!
    var equationArray = [Character]()
    
    var result: Int?
    
    @IBOutlet weak var calculateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        equationLabel.isHidden = true
        ansLabel.isHidden = true
        
        equationText.delegate = self
        equationText.keyboardType = .default
        // Do any additional setup after loading the view.
    }
    
    func multiplication(){
        for (index,equation) in equationArray.enumerated() {
            if equation == "*"{
                result = Int(String(equationArray[index - 1]))! * Int(String(equationArray[index + 1]))!
                equationArray[index] = "x"
                if index < 3{
                    equationArray[index - 1] = "x"
                    equationArray[index + 1] = Character(String(result!))
                } else {
                    equationArray[index + 1] = "x"
                    equationArray[index - 1] = Character(String(result!))
                }
                equationArray = equationArray.filter{$0 != "x"}
                print("In Multiplication")
                print(equationArray)
                break
            }
        }
    }
    
    func addition(){
        print(equationArray)
        for (index,equation) in equationArray.enumerated() {
            if equationArray.contains("*") {
                break
            }
            
            if equation == "+"{
                result = Int(String(equationArray[index - 1]))! + Int(String(equationArray[index + 1]))!
                equationArray[index] = "x"
                if index < 3{
                    equationArray[index - 1] = "x"
                    equationArray[index + 1] = Character(String(result!))
                } else {
                    equationArray[index + 1] = "x"
                    equationArray[index - 1] = Character(String(result!))
                }
                equationArray = equationArray.filter{$0 != "x"}
                print("In +")
                print(equationArray)
                break
            }
        }
    }
    
    func division(){
        for (index,equation) in equationArray.enumerated() {
            if equationArray.contains("*") || equationArray.contains("+") {
                break
            }
            
            if equation == "/"{
                result = Int(String(equationArray[index - 1]))! / Int(String(equationArray[index + 1]))!
                equationArray[index] = "x"
                if index < 3{
                    equationArray[index - 1] = "x"
                    equationArray[index + 1] = Character(String(result!))
                } else {
                    equationArray[index + 1] = "x"
                    equationArray[index - 1] = Character(String(result!))
                }
                equationArray = equationArray.filter{$0 != "x"}
                print("In /")
                print(equationArray)
                break
            }
            
        }
    }
    
    func subtraction(){
        for (index,equation) in equationArray.enumerated() {
            
            if equationArray.contains("*") || equationArray.contains("+") || equationArray.contains("/") {
                break
            }
            
            if equation == "-"{
                result = Int(String(equationArray[index - 1]))! - Int(String(equationArray[index + 1]))!
                equationArray[index] = "x"
                if index < 3{
                    equationArray[index - 1] = "x"
                    equationArray[index + 1] = Character(String(result!))
                } else {
                    equationArray[index + 1] = "x"
                    equationArray[index - 1] = Character(String(result!))
                }
                equationArray = equationArray.filter{$0 != "x"}
                print("In -")
                print(equationArray)
                break
            }
        }
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        if !(equationText.text?.isEmpty)! {
            equationLabel.isHidden = false
            equationLabel.text = "Equation is: " + equationText.text!
            
            equationArray = Array(equationText.text!)
            print(equationArray)
            
            while equationArray.count > 1 {
                if equationArray.contains("*") {
                    multiplication()
                    equationArray = equationArray.filter{$0 != "x"}
                    print(equationArray)
                }else if equationArray.contains("+") {
                    addition()
                    equationArray = equationArray.filter{$0 != "x"}
                    print(equationArray)
                }else if equationArray.contains("/") {
                    division()
                    equationArray = equationArray.filter{$0 != "x"}
                    print(equationArray)
                }else if equationArray.contains("-") {
                    subtraction()
                    equationArray = equationArray.filter{$0 != "x"}
                    print(equationArray)
                }
            }
            
            ansLabel.isHidden = false
            ansLabel.text = "Ans: " + String(result!)
        }
    }
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("error: there was a problem logging out")
        }
    }
}

extension CalculatorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        calculateButtonTapped(calculateButton)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == equationText {
            let allowedCharacters = CharacterSet(charactersIn:"+-*/0123456789 ")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
