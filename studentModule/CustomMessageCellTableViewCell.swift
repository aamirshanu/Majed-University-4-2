//
//  CustomMessageCellTableViewCell.swift
//  studentModule
//
//  Created by mac on 16/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class CustomMessageCellTableViewCell: UITableViewCell {

   
    @IBOutlet weak var rightviewConstrant: NSLayoutConstraint!
    @IBOutlet weak var leftViewConstrant: NSLayoutConstraint!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var senderUsername: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
        // Configure the view for the selected state
    }
    
}
