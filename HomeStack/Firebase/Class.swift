//
//  Class.swift
//  HomeStack
//
//  Created by Felix Moses on 3/3/18.
//  Copyright © 2018 Felix Moses. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Class {
    //MARK: Properties
    let user: User
    
    //MARK: Methods
    class func showConversations(completion: @escaping ([Class]) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            var conversations = [Class]()
            Database.database().reference().child("users").child(currentUserID).child("classes").observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    let fromID = snapshot.key
                    let values = snapshot.value as! [String: String]
                    let location = values["location"]!
                    User.info(forUserID: fromID, completion: { (user) in
                        let emptyMessage = Message.init(content: "loading")
                        let conversation = Class.init(user: user)
                        conversations.append(conversation)
                    })
                }
            })
        }
    }
    
    //MARK: Inits
    init(user: User) {
        self.user = user
    }
}
