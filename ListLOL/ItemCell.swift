//
//  ItemCell.swift
//  ListLOL
//
//  Created by Michal Chorobik on 2017-07-23.
//  Copyright © 2017 Michal Chorobik. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    
    func configureCell(item: Item){
        
        title.text = item.title
        thumb.image = item.image1 as? UIImage
        
        thumb.layer.cornerRadius = thumb.frame.size.width/2
        thumb.clipsToBounds = true
        
        checkBox.layer.cornerRadius = checkBox.frame.size.width/2
        checkBox.clipsToBounds = true
        
        
    }
    
}
