import Foundation
import UIKit
import Firebase

class Class {
    static let ref = Database.database().reference().child("classes")
    
    //comments
    var callback: (senderData) -> Swift.Void = { (data: senderData) in }
    var commentsRef: DatabaseReference = Class.ref
    var comments: [senderData] = []
    
    //work
    var work_callback: (Homework) -> Swift.Void = { (data: Homework) in }
    var workRef: DatabaseReference = Class.ref
    var work: [Homework] = []
    
    //info
    var name : String
    var teacher : String
    var period : Int
    
    class func loadAll(callback: @escaping ([Class]) -> Swift.Void ) {
        Class.ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var ret: [Class] = []
            for var path:Any in snapshot.children {
                var snap: DataSnapshot = (path as! DataSnapshot)
                ret.append( Class(name: snap.childSnapshot(forPath: "name").value as! String, teacher: snap.childSnapshot(forPath: "teacher").value as! String, period: snap.childSnapshot(forPath: "period").value as! Int ) )
            }
            callback(ret)
        })
    }
    
    func addHomework(name: String, description: String, img: UIImage) {
        Homework.upload(clas: self, name: name, img: img, callback: { (img: UIImage) in
            Class.ref.child(self.name + "_" + self.teacher + "_" + String(self.period) + "/homework/" + name).setValue(["name" : name,"description" : description])
        })
    }
    
    func post(comment: String) {
        commentsRef.child(String(self.comments.count + 1) ).setValue(["id" : User.id, "msg" : comment])
    }
    
    func load() {
        //comments
        self.commentsRef = Class.ref.child(name + "_" + teacher + "_" + String(period) + "/comments")
        self.commentsRef.observe(.childAdded, with: { (snapshot) -> Void in
            self.comments.append( senderData( user: snapshot.childSnapshot(forPath: "id").value as! String, message: snapshot.childSnapshot(forPath: "msg").value as! String) )
            self.callback(self.comments.last!)
        })
        //work
        self.workRef = Class.ref.child(name + "_" + teacher + "_" + String(period) + "/homework")
        self.workRef.observe(.childAdded, with: { (snapshot) -> Void in
            self.work.append( Homework(clas: self, name: snapshot.childSnapshot(forPath: "name").value as! String,  description: snapshot.childSnapshot(forPath: "description").value as? String) )
            self.work_callback(self.work.last!)
        })
    }
    
    init(name: String, teacher: String, period: Int) {
        self.name = name
        self.teacher = teacher
        self.period = period
    }
    
    init(name: String, teacher: String, period: Int, completion: @escaping (Bool, Class) -> Swift.Void) {
        //set values
        self.name = name
        self.teacher = teacher
        self.period = period
        //see if it exist
        Class.ref.child(name + "_" + teacher + "_" + String(period)).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("name") {
                //load
                self.load()
                //true callback
                completion(true, self)
            } else {
                //alert it dosent exist
                let alert = UIAlertController(title: "Class does not exist!", message: "Do you want to creat the class?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Back"), style: .`default`, handler: { _ in
                    //false callback
                    completion(false, self)
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Creat"), style: .`default`, handler: { _ in
                    //upload class
                    Class.ref.child(name + "_" + teacher + "_" + String(period) + "/name").setValue(name)
                    Class.ref.child(name + "_" + teacher + "_" + String(period) + "/teacher").setValue(teacher)
                    Class.ref.child(name + "_" + teacher + "_" + String(period) + "/period").setValue(period)
                    //load
                    self.load()
                    //true callback
                    completion(true, self)
                }))
                //show alert
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    topController.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
}
