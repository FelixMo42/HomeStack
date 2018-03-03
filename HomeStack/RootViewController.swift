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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = allClasses.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath  )
        
        
        let viewInCell = cell.viewWithTag(1)
        viewInCell?.layer.cornerRadius = 5
        //
        //        let background = cell.viewWithTag(1)
        //        background?.backgroundColor = Color.blue.lighten2
        //
        //        let title = cell.viewWithTag(2) as! UILabel
        //        title.textColor = UIColor.white
        //        title.text = "Class: \(indexPath.row)"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 400, height: 140)
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

