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
        
        //Checking the creation date and the completion date to determine if the task should be deleted from the table view
        var date = Date()
        let todaysDate = Calendar.current
        let components = todaysDate.dateComponents([.year, .month , .day], from: date)
        
        date = item.created as! Date
        let components2 = todaysDate.dateComponents([.year, .month , .day], from: date)

        
        if item.toItemType?.type == "today" {
            if((Int(components2.day!) - Int(components.day!)) != 0 || (Int(components2.year!) - Int(components.year!)) != 0 || (Int(components2.month!) - Int(components.month!)) != 0){
                if(item.image2 != UIImage(named: "unchecked")){
                    print("deleted")
                    context.delete(item)
                }else{
                    //if the time period for this item expires and it is not checked it gets reassigned a new date so that it is moved to the new day,week,month,year
                    item.created = Date() as NSDate?
                }
            }
            print ("created \(components2.day!)")
            print ("today \(components.day!)")
        }
        
        if item.toItemType?.type == "this month" {
            if((Int(components2.month!) - Int(components.month!)) != 0 || (Int(components2.year!) - Int(components.year!)) != 0){
                if(item.image2 != UIImage(named: "unchecked")){
                    print("deleted")
                    context.delete(item)
                }else{
                    item.created = Date() as NSDate?
                }
            }
            print ("created \(components2.day!)")
            print ("today \(components.day!)")
        }
        
        if item.toItemType?.type == "this year" {
            if((Int(components2.year!) - Int(components.year!)) != 0){
                if(item.image2 != UIImage(named: "unchecked")){
                    print("deleted")
                    context.delete(item)
                }else{
                    item.created = Date() as NSDate?
                }
            }
            print ("created \(components2.day!)")
            print ("today \(components.day!)")
        }
        if item.toItemType?.type == "this week" {
            if((Int(components2.month!) - Int(components.month!)) != 0 || (Int(components2.year!) - Int(components.year!)) != 0){
                if ((Int(components2.day!) - Int(components.day!)) > 7 || (Int(components2.day!) - Int(components.day!)) < 7) {
                    if(item.image2 != UIImage(named: "unchecked")){
                        print("deleted")
                        context.delete(item)
                    }else{
                        item.created = Date() as NSDate?
                    }
                }
            }
            print ("created \(components2.day!)")
            print ("today \(components.day!)")
        }
        
    }
}
