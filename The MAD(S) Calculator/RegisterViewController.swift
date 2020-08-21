//
//  RegisterViewController.swift
//  The MAD(S) Calculator
//
//  Created by Geekyworks on 20/08/20.
//  Copyright © 2020 Rohit Nikam. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func registerPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        //Set up a new user on our Firebase database
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Registration Successful!")
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToCalculator", sender: self)
            }
        }
    }
}
