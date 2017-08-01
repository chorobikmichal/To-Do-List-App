//
//  ItemCell.swift
//  ListLOL
//
//  Created by Michal Chorobik on 2017-07-23.
//  Copyright © 2017 Michal Chorobik. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func configureCell(item: Item){
        
        title.text = item.title
        thumb.image = item.image1 as? UIImage
        checkBox.setImage( item.image2 as! UIImage? , for: .normal)
        
        
        thumb.layer.cornerRadius = thumb.frame.size.width/2
        thumb.clipsToBounds = true
        
        //checkBox.layer.cornerRadius = checkBox.frame.size.width/2
        //checkBox.clipsToBounds = true
        
        
    }
    
}
