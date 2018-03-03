//
//  ViewController.swift
//  SnapLike
//
//  Created by Kartikeya Saxena Jain on 10/21/15.
//  Copyright © 2015 Kartikeya Saxena Jain. All rights reserved.
//

import UIKit
import Material

class RootViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var allClasses: UICollectionView!
    let screenSize = UIScreen.main.bounds
    var allColors:[UIColor] = [Color.green.darken1, Color.blue.darken1, Color.red.darken1,Color.yellow.darken1,Color.orange.darken1,Color.purple.darken1]
    

    
    var enrolledClasses:[EnrolledClass] = [
        EnrolledClass(name:"History", students:22, period:"Period 1", teacher:"Mr. Plonsey"),
        EnrolledClass(name:"Math", students:21, period:"Period 2", teacher:"Ms. Plescotch"),
        EnrolledClass(name:"French", students:23, period:"Period 3", teacher:"Ms. Moreno"),
        EnrolledClass(name:"English", students:19, period:"Period 4", teacher:"Ms. Meyer"),
        EnrolledClass(name:"Computer Science", students:17, period:"Period 5", teacher:"Ms. Warriner"),
        EnrolledClass(name:"AP Java", students:20, period:"Period 6", teacher:"Mr. Sanguine"),
    ]
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return enrolledClasses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = allClasses.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath  )
        
        let currentClass = enrolledClasses[indexPath.row]
        
        let background = cell.viewWithTag(1)
        background?.layer.cornerRadius = 5
        background?.backgroundColor = allColors[indexPath.row]
        
        let title = cell.viewWithTag(2) as! UILabel
        title.text = currentClass.name
        
        let period = cell.viewWithTag(3) as! UILabel
        period.text = currentClass.period
        
        let teacher = cell.viewWithTag(4) as! UILabel
        teacher.text = currentClass.teacher
        
        let students = cell.viewWithTag(5) as! UILabel
        students.text = String( currentClass.students )

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: screenSize.width - 15, height: 120)
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "rootToChat", sender: self)
        current.selectedClass = enrolledClasses[indexPath.row].name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        allClasses.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        navigationController?.navigationBar.backgroundColor = Color.blue.lighten2
        
        let menu = IconButton(image: Icon.cm.menu)
        menu.tintColor = Color.white
        let plus = IconButton(image: Icon.cm.add)
        plus.tintColor = Color.white
        
        navigationItem.leftViews = [menu]
        navigationItem.rightViews = [plus]
        navigationItem.titleLabel.text = "Classes"
        navigationItem.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleLabel.textColor = Color.white
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

