//
//  AdvisorMessageTableViewCell.swift
//  studentModule
//
//  Created by mac on 28/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AdvisorMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSender: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
