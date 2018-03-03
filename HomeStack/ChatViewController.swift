//
//  ChatViewController.swift
//  HomeStack
//
//  Created by Andre Assadi on 3/3/18.
//  Copyright © 2018 Felix Moses. All rights reserved.
//

import UIKit
import Material

class ChatViewController: UIViewController, UICollectionViewDelegate,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var images: UICollectionView!
    
    var allColors:[UIColor] = [Color.green.darken1, Color.blue.darken1, Color.red.darken1,Color.yellow.darken1,Color.orange.darken1,Color.purple.darken1]
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = images.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath  )
        let view = cell.viewWithTag(1)
        view?.backgroundColor = allColors[indexPath.row]
        
        return cell
    }
    
    let screenSize = UIScreen.main.bounds
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: screenSize.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let menu = IconButton(image: Icon.cm.menu)
        menu.tintColor = Color.white
        let plus = IconButton(image: Icon.cm.add)
        plus.tintColor = Color.white
        
        let backButtonImage = IconButton(image: Icon.cm.arrowBack)
        backButtonImage.tintColor = Color.white
        
        navigationBar.backButtonImage = backButtonImage
        // =
        navigationItem.rightViews = [plus]
        navigationItem.titleLabel.text = "Classes"
        navigationItem.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleLabel.textColor = Color.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
