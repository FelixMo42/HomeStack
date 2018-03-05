//
//  SelectPictureViewController.swift
//  HomeStack
//
//  Created by Andre Assadi on 3/3/18.
//  Copyright © 2018 Felix Moses. All rights reserved.
//

import UIKit
import Material

class SelectPictureViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var name: TextField!
    @IBOutlet weak var theDescription: TextView!
    @IBOutlet weak var currentImage: UIImageView!
    
    @IBOutlet weak var postButton: UIButton!
    let picker = UIImagePickerController()
    let secondPicker = UIImagePickerController()
    
    func takePhoto()  {
        picker.sourceType = .camera
        self.present(picker, animated: true)
    }
    
    func chosePhoto()   {
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    @objc func selectPicture() {
        
        let alert = UIAlertController(title: "Chose", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler:{ _ in
            self.takePhoto()
        }))
        alert.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertActionStyle.default, handler:{ _ in
            self.chosePhoto()
        } ))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func didPost(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        current.selectedClass.addHomework(name: name.text!, description: theDescription.text!, img: currentImage.image!)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        // do something interesting here!
        currentImage.image = newImage
        
        dismiss(animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        name.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            theDescription.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.allowsEditing = true
        picker.delegate = self
        secondPicker.delegate = self
        name.delegate = self
        theDescription.delegate = self
        
        navigationItem.titleLabel.text = "Add Homework"
        navigationItem.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleLabel.textColor = Color.white
        
        currentImage.isUserInteractionEnabled = true
        currentImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPicture)))
        
    }

}
