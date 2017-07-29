//
//  ItemsDetailsVC.swift
//  ListLOL
//
//  Created by Michal Chorobik on 2017-07-24.
//  Copyright © 2017 Michal Chorobik. All rights reserved.
//

import UIKit
import CoreData

class ItemsDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    //@IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var newImg: UIImageView!

    
    //we want to do newImg.image = The image choosen in ImggalleryVC
    
    var categories = [ItemType]()
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        /*let category1 = ItemType(context: context)
        category1.type = "today"
        
        let category2 = ItemType(context: context)
        category2.type = "this week"
        
        let category3 = ItemType(context: context)
        category3.type = "this month"
        
        let category4 = ItemType(context: context)
        category4.type = "this year"

        ad.saveContext()*/
        getStores()
        
        if itemToEdit != nil{
            //means we are editing an item and call a func i made
            
            loadItemData()
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = categories[row]
        return category.type
    }
    
    //rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categories.count
    }
   
    //columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    func getStores(){
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do{
            self.categories = try context.fetch(fetchRequest)
            self.categoryPicker.reloadAllComponents()
        }catch{
            //error handling
        }
    }
    
    
    @IBAction func sevePressed(_ sender: UIButton) {
        
        var item: Item!
        
        if itemToEdit == nil{
            item = Item(context: context)
        }else{
            item = itemToEdit
        }
        
        if let title = titleField.text{
            item.title = title
        }
        
        
        /*******************************************************************/
        
        if(item.image1 == nil){
            newImg.image = UIImage(named: "imagePick.jpg")
            item.image1 = newImg.image
        }else{
             item.image1 = newImg.image        }
        
        
        
        /*******************************************************************/
        
        //we only have one column in the picker so that why ""categoryPicker.selectedRow(inComponent: 0)"" says 0
        item.toItemType = categories[categoryPicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        //go back to previous screen
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func newImgPressed(_ sender: Any) {
        performSegue(withIdentifier: "galleryVC", sender: newImg)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "galleryVC"{
            if let destination = segue.destination as? ImgGalleryVC{
                    newImg.image = destination.imgg
            }
        }
    }
    
    func loadItemData(){
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            
            if let itemType = item.toItemType {
                
                var index = 0
                repeat{
                    
                    let t = categories[index]
                    if t.type == itemType.type {
                        categoryPicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                }while (index < categories.count)
            }
            
        }
        
    }
    
    
    @IBAction func deletePressed(_ sender: Any) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    
    
}
