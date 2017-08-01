//
//  ItemsDetailsVC.swift
//  ListLOL
//
//  Created by Michal Chorobik on 2017-07-24.
//  Copyright © 2017 Michal Chorobik. All rights reserved.
//

import UIKit
import CoreData

class ItemsDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var newImg: UIImageView!

    
    //we want to do newImg.image = The image choosen in ImggalleryVC
    
    var categories = [ItemType]()
    var itemToEdit: Item?
    var newItem: Item!


    override func viewDidLoad() {
        super.viewDidLoad()

        //so i can hide the keyboard
        self.titleField.delegate = self
        
        
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
        
        newImg.layer.cornerRadius = newImg.frame.size.width/2
        newImg.clipsToBounds = true
        
        if(newItem != nil){
            newImg.image = newItem.image1 as! UIImage?
        } else if itemToEdit != nil{
            newImg.image = itemToEdit?.image1 as! UIImage?
        }
        

        
    }
    
    //once user touches outside keyboard it dissapears
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        return true
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

        
        if itemToEdit == nil && newItem == nil {
            newItem = Item(context: context)
            newImg.image = UIImage(named: "imagePick.jpg")
            newItem.image1 = newImg.image
            newItem.image2 = UIImage(named: "unchecked.jpg")
            
            //whitout this line my cells would get duplicated in the table view
            ad.saveContext()
            
        }else if itemToEdit != nil {
            newItem = itemToEdit
            newImg.image = newItem.image1 as! UIImage?
        }
        
        if let title = titleField.text{
            newItem.title = title
        }
        
        //we only have one column in the picker so that why ""categoryPicker.selectedRow(inComponent: 0)"" says 0
        newItem.toItemType = categories[categoryPicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        //go back to previous screen
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func imgButtonPressed(_ sender: Any) {
        
        if itemToEdit != nil {
            performSegue(withIdentifier: "galleryVC", sender: itemToEdit)
        } else if itemToEdit == nil {
            newItem = Item(context: context)
            newItem.image1 = UIImage(named: "imagePick.jpg")
            newItem.image2 = UIImage(named: "unchecked.jpg")

            performSegue(withIdentifier: "galleryVC", sender: newItem)
        }

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "galleryVC"{
            if let destination = segue.destination as? ImgGalleryVC{
                if let item = sender as? Item {
                    destination.itemEdit = item
                }
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
    
    func reloadThumbImg() {
    
        if(newItem != nil){
            newImg.image = newItem.image1 as! UIImage?
        } else if itemToEdit != nil{
            newImg.image = itemToEdit?.image1 as! UIImage?
        }
        
        if(newImg == nil){
            newImg.image = UIImage(named: "abc.jpg")
        }
        
    }
    
    //5 Lines of code send to me by GOD!!!!!!
    //tells me when this controller is being currentlly viewed so that i can refresh it
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            print("!!!!!111!!!!!!!")
            reloadThumbImg()
    }
    
}
