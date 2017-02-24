//
//  MessageTableViewCell.swift
//  ParseChat
//
//  Created by Jiapei Liang on 2/23/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Parse

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var message: PFObject! {
        didSet {
            if let text = message["text"] as? String {
                messageLabel.text = text
            }
            
            if let user = message["user"] as? PFUser {
                usernameLabel.text = user.username
            }
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
