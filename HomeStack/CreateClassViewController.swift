//
//  CreateClassViewController.swift
//  HomeStack
//
//  Created by Andre Assadi on 3/3/18.
//  Copyright © 2018 Felix Moses. All rights reserved.
//

import UIKit
import Material

class CreateClassViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var name: TextField!
    @IBOutlet weak var level: TextField!
    @IBOutlet weak var pronounSelection: UISegmentedControl!
    @IBOutlet weak var teacherName: TextField!
    @IBOutlet weak var period: TextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        level.delegate = self
        teacherName.delegate = self
        period.delegate = self
        
        navigationItem.titleLabel.text = "New Class"
        navigationItem.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleLabel.textColor = Color.white

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createNewClass(_ sender: Any){
        let className = level.text! + " " + self.name.text!
        let teacherName = self.pronounSelection.titleForSegment(at: self.pronounSelection.selectedSegmentIndex)! + " " + self.teacherName.text!
        let period = Int(self.period.text!)!
        
        User.addClass(name: className, teacher: teacherName, period: period, completion: { (suc: Bool) in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
