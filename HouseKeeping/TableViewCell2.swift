//
//  TableViewCell2.swift
//  HouseKeeping
//
//  Created by Apple-1 on 09/01/18.
//  Copyright © 2018 Apple-1. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
