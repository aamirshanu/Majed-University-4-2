//
//  User.swift
//  studentModule
//
//  Created by mac on 02/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

class User {
    var name = ""
    var email = ""
    var id = ""
    
    init(userDict: [String:String]) {
        self.name = userDict["name"]!
        self.email = userDict["email"]!
    }
}
