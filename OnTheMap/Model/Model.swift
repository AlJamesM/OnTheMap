//
//  Model.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 9/6/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation

class Model {
    
    static let shradeInstance = Model()
    
    var studentLocations = [StudentInformation]()
    
    private init() {}
    
    func updateModel(_ studentArray : [[String: AnyObject]]) {
        
        self.studentLocations.removeAll()
        
        for dictionary in studentArray {
            
            let student = StudentInformation.init(dictionary)
            studentLocations.append(student)
        }
    }
}
