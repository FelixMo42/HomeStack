//
//  Comment.swift
//  HomeStack
//
//  Created by Felix Moses on 3/3/18.
//  Copyright © 2018 Felix Moses. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Homework {
    static let stor = Storage.storage().reference()

    var img: UIImage
    var name: String
    var description: String?
    
    class func upload(clas: Class, name: String, img: UIImage, callback: @escaping (UIImage) -> Swift.Void) {
        var img: UIImage = Homework.resizeImage(image: img, width: 600, height: 600)
        let imgRef = Homework.stor.child("images/" + clas.name + "/" + name + ".png")
        _ = imgRef.putData(UIImagePNGRepresentation(img) as! Data, metadata: nil, completion: { (s:StorageMetadata?, e:Error?) in
            print(e)
            callback(img)
        })
    }
    
    init(clas: Class, name: String, description: String?) {
        self.name = name
        self.description = description
        
        let imgRef = Homework.stor.child("images/" + clas.name + "/" + name + ".png")
        
        self.img = UIImage()
        
        var _ = imgRef.getData(maxSize: 1 * 1024 * 1024, completion: { data, error in
            if error == nil {
                self.img = UIImage(data: data!)!
            }
        })
    }
    
    class func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let size = image.size
        
        let widthRatio  = width / size.width
        let heightRatio = height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: width * heightRatio, height: height * heightRatio)
        } else {
            newSize = CGSize(width: width * widthRatio,  height: height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
