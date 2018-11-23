//
//  MyCell.swift
//  MapViewUse1122
//
//  Created by 503-12 on 23/11/2018.
//  Copyright © 2018 The. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
