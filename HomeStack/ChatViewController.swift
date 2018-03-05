//
//  ChatViewController.swift
//  HomeStack
//
//  Created by Andre Assadi on 3/3/18.
//  Copyright © 2018 Felix Moses. All rights reserved.
//

import UIKit
import Material

struct senderData {
    
    let user:String
    let message:String
    
    init(user:String,message:String) {
        self.user = user
        self.message = message
    }
    
}

class ChatViewController: UIViewController, UICollectionViewDelegate,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var imagesPageControl: UIPageControl!
    @IBOutlet weak var images: UICollectionView!
    @IBOutlet weak var textBox: UIView!
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var sendData: UIButton!
    @IBOutlet weak var theSrollView: UIScrollView!
    
    var textBoxAlreadyMoved = false
    var allSendData:[senderData] = []
    
    var allColors:[UIColor] = [Color.green.darken1, Color.blue.darken1, Color.red.darken1,Color.yellow.darken1,Color.orange.darken1,Color.purple.darken1]
    
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(current.selectedClass.work.count , 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = images.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath  )
        let homeworkToDisplay = cell.viewWithTag(1) as! UIImageView
        
        
        if current.selectedClass.work.count == 0 {
            homeworkToDisplay.image = UIImage(named:"noPosts")
        }
        else {
            homeworkToDisplay.image = current.selectedClass.work[indexPath.row].img
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSendData.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        var message = chatTableView.dequeueReusableCell(withIdentifier: "response", for: indexPath  )
        
        if  allSendData[indexPath.row].user == User.id {
            message = chatTableView.dequeueReusableCell(withIdentifier: "yourMessage", for: indexPath  )
            message.selectionStyle = .none
            let label = message.viewWithTag(1) as! UILabel
            label.text = allSendData[indexPath.row].message
            let background = message.viewWithTag(2) as! UIView
            background.layer.cornerRadius = 5
            background.frame.size.width = CGFloat( (label.text!.count * 10) + 14)
            let name = message.viewWithTag(3) as! UILabel

            if indexPath.row >= 1 {
                if allSendData[indexPath.row - 1].user == User.id {
                    name.text = ""
                }
                else {
                    let name = message.viewWithTag(3) as! UILabel
                    name.text = "You"
                }
            }
            else {
                name.text = "You"
            }

            
        }
        else {
            
            message = chatTableView.dequeueReusableCell(withIdentifier: "response", for: indexPath  )
            message.selectionStyle = .none

            let label = message.viewWithTag(1) as! UILabel
            label.text = allSendData[indexPath.row].message
            let background = message.viewWithTag(2) as! UIView
            background.layer.cornerRadius = 5
            background.frame.size.width = CGFloat( (label.text!.count * 10) + 14)
            background.frame.origin.x = 368 - CGFloat( (label.text!.count * 10) + 14)
            background.backgroundColor = Color.orange.lighten1
            let name = message.viewWithTag(3) as! UILabel
            
            if indexPath.row >= 1 {
                if allSendData[indexPath.row - 1].user == allSendData[indexPath.row].user {
                    name.text = ""
                }
                else {
                    let name = message.viewWithTag(3) as! UILabel
                    User.getName( id: allSendData[indexPath.row].user , callback: { (t: String) in
                        name.text = t
                    } )
                    
                }
            }
            else {
                User.getName( id: allSendData[indexPath.row].user , callback: { (t: String) in
                    name.text = t
                } )
            }
            
            
        }

        return message
    }
    
    let screenSize = UIScreen.main.bounds
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textBoxAlreadyMoved == false {
            
            theSrollView.setContentOffset(CGPoint(x:0,y:230), animated: true)
            UIView.animate(withDuration:0.3 , delay:0, options: [], animations: {
                self.textBox.frame.origin.y -= 258
                self.textBoxAlreadyMoved = true
            },completion: nil )
        }
        

    }
    

    
    @IBAction func clickSend(_ sender: Any) {
        current.selectedClass.post(comment: sendTextField.text!)
        sendTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTextField.resignFirstResponder()
        
        if textBoxAlreadyMoved == true {
            UIView.animate(withDuration:0.3 , delay:0, options: [], animations: {
                self.textBox.frame.origin.y += 258
                self.textBoxAlreadyMoved = false
            },completion: nil )
            theSrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
            
        }

        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        print(screenSize.width)
        return CGSize(width: screenSize.width, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imagesPageControl.currentPage = Int(images.contentOffset.x/CGFloat(view.frame.width))
    }
    
    
    @objc func touched() {
        self.performSegue(withIdentifier: "mainToPicture", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.allSendData = current.selectedClass.comments
        
        chatTableView.delegate = self
        sendTextField.delegate = self
        imagesPageControl.numberOfPages = current.selectedClass.work.count
        let menu = IconButton(image: Icon.cm.menu)
        menu.tintColor = Color.white
        let plus = IconButton(image: Icon.cm.pen)
        plus.tintColor = Color.white
        
        let backButtonImage = IconButton(image: Icon.cm.arrowBack)
        backButtonImage.tintColor = Color.white
        // =
        navigationItem.rightViews = [plus]
        
        //mainToPicture
        navigationItem.titleLabel.text = current.selectedClass.name
        navigationItem.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleLabel.textColor = Color.white
        // Do any additional setup after loading the view.
        navigationItem.rightViews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touched)))
        
        current.selectedClass.callback = { (data: senderData) in
            self.allSendData.append(data)
            self.chatTableView.reloadData()
        }
        current.selectedClass.work_callback = { (data: Homework) in
            self.images.reloadData()
        }

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)
    }
    
}
