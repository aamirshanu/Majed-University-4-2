//
//  IndividualMessage.swift
//  studentModule
//
//  Created by mac on 02/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import Firebase

class IndividualMessage {
    var toUserId = ""
    var fromUserId = ""
    var text = ""
    var timeStamp = ""
    
    init(dictionary: [String:String]) {
        self.fromUserId = dictionary["fromUserId"]!
        self.toUserId = dictionary["toUserId"]!
        self.text = dictionary["text"]!
    }
    
    var chatPartnerId: String? {
        
        guard let loggedInUserId =  Auth.auth().currentUser?.uid else {
            return nil
        }
        
        let chatPartnerId = fromUserId == loggedInUserId ? toUserId : fromUserId
        return chatPartnerId
    }
}
