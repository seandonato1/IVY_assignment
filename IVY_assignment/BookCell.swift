//
//  BookCell.swift
//  IVY_assignment
//
//  Created by Sean Donato on 6/21/18.
//  Copyright © 2018 Sean Donato. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var topLabelBC: UILabel!
    
    @IBOutlet weak var bottomLabelBC: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
