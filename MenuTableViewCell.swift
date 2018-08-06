//
//  MenuTableViewCell.swift
//  Slide out menu
//
//  Created by Tristan Brankovic on 8/5/18.
//  Copyright © 2018 parab3llum. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var selectedView: UIView!
    
    var storyboardID = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
