//
//  MyTableViewCell.swift
//  Collaboration
//
//  Created by Kitti Almasy on 2/5/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import Foundation
import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myTextLabel: UITextField!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}




