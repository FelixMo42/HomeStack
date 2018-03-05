import Foundation
import UIKit
import Firebase

class User: NSObject {
    static let ref = Database.database().reference().child("users")
    
    static var name: String = ""
    static var email: String = ""
    static var id: String = ""
    static var classes: [Class] = []
    
    class func getName(id: String, callback: @escaping (String) -> Swift.Void) {
        User.ref.child(id).observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            callback( snapshot.childSnapshot(forPath: "name").value as! String )
        })
    }
    
    class func register(name: String, email: String, psw: String, completion: @escaping (Bool,Error?) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: psw) { (user, error) in
            if error == nil {
                User.name = name
                User.email = email
                User.name = name
                User.id = user!.uid
                
                User.ref.child(user!.uid + "/name").setValue(name)
                
                completion(true,error)
            } else {
                completion(false,error)
            }
        }
    }
    
    class func login(email: String, psw: String, completion: @escaping (Bool,Error?) -> Swift.Void) {
        Auth.auth().signIn(withEmail: email, password: psw) { (user, error) in
            if error == nil {
                User.email = email
                User.id = user!.uid
                User.ref.child(user!.uid).observeSingleEvent(of: .value, with: { snapshot in
                    if !snapshot.exists() { return }
                    
                    let name = snapshot.childSnapshot(forPath: "name").value
                    User.name = name as! String
                    
                    var n: Int = -1
                    var i: Int = 1
                    for _:Any in snapshot.childSnapshot(forPath: "classes").children {
                        Class(name: snapshot.childSnapshot(forPath: "classes/"+String(i)+"/name").value as! String, teacher: snapshot.childSnapshot(forPath: "classes/"+String(i)+"/teacher").value as! String, period: snapshot.childSnapshot(forPath: "classes/"+String(i)+"/period").value as! Int, completion: { (suc: Bool, c:Class) in
                            User.classes.append(c)
                            n = n - 1
                            if n + i == 0 {
                                completion(true,error)
                            }
                        })
                        i = i + 1
                    }
                    if i == 1 {
                        completion(true,error)
                    }
                })
            } else {
                completion(false,error)
            }
        }
    }
    
    
    
    class func addClass(name: String, teacher: String, period: Int, completion: @escaping (Bool) -> Swift.Void) {
        var _: Class = Class(name: name,teacher: teacher,period: period, completion: { (suc: Bool, c: Class) in
            if (suc) {
                User.classes.append( c )
                
                User.ref.child(User.id + "/classes/" + String(User.classes.count) + "/name").setValue(name)
                User.ref.child(User.id + "/classes/" + String(User.classes.count) + "/teacher").setValue(teacher)
                User.ref.child(User.id + "/classes/" + String(User.classes.count) + "/period").setValue(period)
                
                completion(true)
            } else {
                completion(false)
            }
        })
    }
}
