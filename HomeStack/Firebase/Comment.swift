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

class Comment {
    
    //MARK: Properties
    var content: Any
    
    //MARK: Methods
    class func downloadAllMessages(forUserID: String, completion: @escaping (Comment) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(currentUserID).child("conversations").child(forUserID).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    Database.database().reference().child("conversations").child(location).observe(.childAdded, with: { (snap) in
                        if snap.exists() {
                            let receivedMessage = snap.value as! [String: Any]
                            let content = receivedMessage["content"] as! String
                            let message = Comment.init(content: content)
                            completion(message)
                        }
                    })
                }
            })
        }
    }
    
    class func markMessagesRead(forUserID: String)  {
        if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(currentUserID).child("conversations").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    Database.database().reference().child("conversations").child(location).observeSingleEvent(of: .value, with: { (snap) in
                        if snap.exists() {
                            for item in snap.children {
                                let receivedMessage = (item as! DataSnapshot).value as! [String: Any]
                                let fromID = receivedMessage["fromID"] as! String
                                if fromID != currentUserID {
                                    Database.database().reference().child("conversations").child(location).child((item as! DataSnapshot).key).child("isRead").setValue(true)
                                }
                            }
                        }
                    })
                }
            })
        }
    }
    
    func downloadLastMessage(forLocation: String, completion: @escaping () -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("conversations").child(forLocation).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    for snap in snapshot.children {
                        let receivedMessage = (snap as! DataSnapshot).value as! [String: Any]
                        self.content = receivedMessage["content"]!
                        completion()
                    }
                }
            })
        }
    }
    
    class func send(message: Comment, toID: String, completion: @escaping (Bool) -> Swift.Void)  {
        if let currentUserID = Auth.auth().currentUser?.uid {
            let values = ["content": message.content]
            Comment.uploadMessage(withValues: values, toID: toID, completion: { (status) in
                completion(status)
            })
        }
    }
    
    class func uploadMessage(withValues: [String: Any], toID: String, completion: @escaping (Bool) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    Database.database().reference().child("conversations").child(location).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
                        if error == nil {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                } else {
                    Database.database().reference().child("conversations").childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
                        let data = ["location": reference.parent!.key]
                        Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).updateChildValues(data)
                        Database.database().reference().child("users").child(toID).child("conversations").child(currentUserID).updateChildValues(data)
                        completion(true)
                    })
                }
            })
        }
    }
    
    //MARK: Inits
    init(content: String) {
        self.content = content
    }
}
