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

struct EquationHistory {
    var equation:String
    var ans:String
}

class CalculatorViewController: UIViewController {

    @IBOutlet weak var equationLabel: UILabel!
    @IBOutlet weak var ansLabel: UILabel!
    @IBOutlet weak var equationText: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var historyView: UIView!

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var label10: UILabel!
    
    var result: Int = 0
    var equationArray = [String]()
    var equationHistoryArray = [EquationHistory](repeating: EquationHistory(equation: "", ans: ""), count: 10)
    var labelArray = [UILabel]()
    static var historyCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        equationLabel.isHidden = true
        ansLabel.isHidden = true
        historyView.isHidden = true
        
        equationText.delegate = self
        equationText.keyboardType = .default
        
        labelArray = [label1,label2,label3,label4,label5,label6,label7,label8,label9,label10]
        // Do any additional setup after loading the view.
    }
    
    func parseEquation(){
        equationArray.removeAll()
        let stringequation = Array(equationText.text!)
        var digits:String = ""
        for eqn in stringequation{
            if (eqn != "*" && eqn != "+" && eqn != "/" && eqn != "-"){
                digits = digits + String(eqn)
            }else {
                equationArray.append(digits)
                equationArray.append(String(eqn))
                digits = ""
            }
        }
        
        if digits != ""{
            equationArray.append(digits)
        }
    }
    
    func multiplication(){
        for (index,equation) in equationArray.enumerated() {
            if equation == "*"{
                result = Int(String(equationArray[index - 1]))! * Int(String(equationArray[index + 1]))!
                equationArray[index] = "x"
                if index < 3{
                    equationArray[index - 1] = "x"
                    equationArray[index + 1] = (String(result))
                } else {
                    equationArray[index + 1] = "x"
                    equationArray[index - 1] = (String(result))
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
                    equationArray[index + 1] = (String(result))
                } else {
                    equationArray[index + 1] = "x"
                    equationArray[index - 1] = (String(result))
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
                    equationArray[index + 1] = (String(result))
                } else {
                    equationArray[index + 1] = "x"
                    equationArray[index - 1] = (String(result))
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
                    equationArray[index + 1] = (String(result))
                } else {
                    equationArray[index + 1] = "x"
                    equationArray[index - 1] = (String(result))
                }
                equationArray = equationArray.filter{$0 != "x"}
                print("In -")
                print(equationArray)
                break
            }
        }
    }
    
    func storeHistory(){
        if CalculatorViewController.historyCount == 10{
            CalculatorViewController.historyCount = 0
        }
        
        let obj = EquationHistory(equation: equationText.text!, ans: String(result))
        equationHistoryArray[CalculatorViewController.historyCount] = obj
        CalculatorViewController.historyCount += 1
    }
    
    func displayHistory(){
    
        for (index,obj) in equationHistoryArray.enumerated() {
            if obj.equation != "" {
                labelArray[index].text = obj.equation + "=" + obj.ans
            }
        }
        
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        historyView.isHidden = true
        
        if !(equationText.text?.isEmpty)! {
            equationLabel.isHidden = false
            equationLabel.text = "Equation is: " + equationText.text!
            
            parseEquation()
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
            
            
            storeHistory()
            equationText.text = ""
            ansLabel.isHidden = false
            ansLabel.text = "Ans: " + String(result)
        }
    }
    
    @IBAction func useAnsButtonTapped(_ sender: UIButton) {
        equationText.text = String(result)
    }
    
    @IBAction func historyButtonTapped(_ sender: UIButton) {
        displayHistory()
        historyView.isHidden = false
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
