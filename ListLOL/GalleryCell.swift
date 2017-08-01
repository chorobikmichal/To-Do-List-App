//
//  GalleryCell.swift
//  ListLOL
//
//  Created by Michal Chorobik on 2017-07-27.
//  Copyright © 2017 Michal Chorobik. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell{
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    //make images rounded
    //it accually make the whole cell rounded not the image itself
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
    }

    func configureCell(x: String){
        thumbImg.image = UIImage(named: x)
    }
    
    
    
}
