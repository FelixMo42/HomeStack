//
//  LoginViewController.swift
//  HomeStack
//
//  Created by Andre Assadi on 3/4/18.
//  Copyright © 2018 Felix Moses. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var loginSegment: UISegmentedControl!
    @IBOutlet weak var passwordField: TextField!
    
    @IBOutlet weak var theScrollView: UIScrollView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailField: TextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if User.id != "" {
            self.performSegue(withIdentifier: "loginToMain", sender: self)
        }
    }
    @IBAction func segmentChanged(_ sender: Any) {
        if loginSegment.titleForSegment(at: loginSegment.selectedSegmentIndex) == "Login" {
            current.login = true
        } else {
            self.performSegue(withIdentifier: "loginToSignup", sender: self)
            current.login = false
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        User.login(email: emailField.text!, psw: passwordField.text!, completion: { (suc: Bool, error: Error?) in
            if suc {
                self.performSegue(withIdentifier: "loginToMain", sender: self)
            } else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        theScrollView.setContentOffset(CGPoint(x:0,y:0),animated:true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        theScrollView.setContentOffset(CGPoint(x:0,y:75), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        theScrollView.delegate = self
        passwordField.delegate = self
        emailField.delegate = self
    }
}
