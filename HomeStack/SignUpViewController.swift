//
//  SignUpViewController.swift
//  HomeStack
//
//  Created by Andre Assadi on 3/4/18.
//  Copyright © 2018 Felix Moses. All rights reserved.
//

import UIKit
import Material

class SignUpViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,UITextFieldDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var usernameField: TextField!
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var passwordField: TextField!

    @IBOutlet weak var schoolField: TextField!
    

    var allSchools = ["Berkeley High School"]
    var currentSchools:[String] = []
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func continueToMain() {
        User.register(name: usernameField.text!, email: emailField.text!, psw: passwordField.text!, completion: { (suc: Bool, error: Error?) in
            if suc {
                self.navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        ) }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentSchools = allSchools
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        table.delegate = self
        searchBar.delegate = self
        
        navigationItem.titleLabel.text = "Sign Up"
        navigationItem.contentViewAlignment = .center
        navigationItem.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleLabel.textColor = Color.white
        navigationController?.navigationBar.backgroundColor = Color.blue.lighten2
        navigationItem.hidesBackButton = true
        let nextIcon = IconButton(title: "Create")
        nextIcon.titleColor = Color.white
        
        let backIcon = IconButton(image: Icon.cm.arrowBack)
        
        navigationItem.leftViews = [backIcon]
        navigationItem.rightViews = [nextIcon]
        navigationItem.leftViews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        navigationItem.rightViews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(continueToMain)))
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            table.reloadData()
            return
            
        }
        currentSchools = allSchools.filter({ (theSchool) -> Bool in
            guard searchBar.text != nil else {return false}
            return theSchool.lowercased().contains(searchBar.text!.lowercased())
        })
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSchools.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        schoolField.text = allSchools[0]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.selectionStyle = .none
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
