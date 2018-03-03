//
//  enrolledClasses.swift
//  HomeStack
//
//  Created by Andre Assadi on 3/3/18.
//  Copyright © 2018 Felix Moses. All rights reserved.
//

import Foundation

class EnrolledClass {
    
    var name:String
    var students:Int
    var period:String
    var teacher:String
    
    init(name:String, students:Int, period:String, teacher:String) {
        
        self.name = name
        self.students = students
        self.period = period
        self.teacher = teacher
        
    }
    
    
    
}
