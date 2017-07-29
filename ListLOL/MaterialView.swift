//
//  MaterialView.swift
//  ListLOL
//
//  Created by Michal Chorobik on 2017-07-23.
//  Copyright © 2017 Michal Chorobik. All rights reserved.
//

import UIKit

private var materialKey = false

extension UIView {
    
    @IBInspectable var materialDesign: Bool {
        
        get {
            return materialKey
        }
        set {
            materialKey = newValue
            
            if(materialKey == true){
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 23.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 1.0).cgColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
        
        
    }
    
}
