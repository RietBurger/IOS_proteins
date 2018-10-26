//
//  connectCellToScene.swift
//  Swifty_Proteins
//
//  Created by Jeanette Henriette BURGER on 2018/10/25.
//  Copyright © 2018 Lance CHANT. All rights reserved.
//

import UIKit

class sceneTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
