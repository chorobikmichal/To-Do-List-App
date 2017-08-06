//
//  MainVC.swift
//  ListLOL
//
//  Created by Michal Chorobik on 2017-07-22.
//  Copyright © 2017 Michal Chorobik. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        attemptFetch()
        
        //another waeditBtnPressed to set up a button action outlet. with different benefits
        let leftBtn = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editBtnPressed))
        self.navigationItem.leftBarButtonItem = leftBtn
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*****************************************table view*********************************************************/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        /***set tag for the cell button to the same as the indexpath of the cell***/
        cell.checkBox.tag = indexPath.row
        cell.checkBox.addTarget(self, action: #selector(CheckAction), for: .touchUpInside)
        //its sopose t obe 230 for rgb but it ends up showing up as 224
        cell.backgroundColor = UIColor(red: 236, green: 236, blue: 236)
        return cell
    }
    
    
    
    func CheckAction (sender: UIButton){
        
        //these lines determine the indexpath of the cell where the button was clicked
        let pointTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRow(at: pointTable)
        
        //here we get the selected cells items core data and switch the image in the button to checked or unchecked
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[(cellIndexPath?.row)!]
            
            if (item.image2 == UIImage(named: "unchecked.jpg")){
                item.image2 = UIImage(named: "checked.jpg")
            } else {
                item.image2 = UIImage(named: "unchecked.jpg")
            }
            //the saves the core data
            ad.saveContext()
        }
        
        print("itssss ---->  \(cellIndexPath)")
        
        //this refreshes the table so the change of the button image can be observed right away
        tableView.reloadData()
        
    }
    
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath){
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    
    var itemForChange: Item?
    
    //any time someone selects an element in the table view I check for if its not empty
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        
        //comma means "where"
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemsDetailsVC", sender: item)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemsDetailsVC"{
            if let destination = segue.destination as? ItemsDetailsVC{
                
                if let item = sender as? Item {
                        destination.itemToEdit = item
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    //assures that the height of each cell is 64 as i want it
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    /**************************************core data************************************************************/

    func attemptFetch(){
        
        
        //fetches the items from core data
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        //sort the items by date
        let posSort = NSSortDescriptor(key: "position", ascending: true)

        //checks which segment is selected (index 0 is the default)
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.predicate = NSPredicate(format: "toItemType.type = %@", "today")
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.predicate = NSPredicate(format: "toItemType.type = %@", "this week")
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.predicate = NSPredicate(format: "toItemType.type = %@", "this month")
        } else if segment.selectedSegmentIndex == 3 {
            fetchRequest.predicate = NSPredicate(format: "toItemType.type = %@", "this year")
        }

        fetchRequest.sortDescriptors = [posSort]
        //fetchRequest.fetchLimit = 2
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        controller.delegate = self
        //self.controller is the controller inside this func and it is assigned the val of the outside contoller
        self.controller = controller
        
        do {
          try controller.performFetch()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
        

        
    }
    
    //segmented controll action outlet
    @IBAction func segmentChange(_ sender: Any) {
        
        attemptFetch()
        tableView.reloadData()
        
    }
    
    
    //will listen for any chnges and update core data
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
            
        case.insert:
            if let indexPath = newIndexPath{
                //.fade is the animation type that will appear
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break

        case.delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
            
        case.move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    //Allow for reordering of cells
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        
        var objects = controller.fetchedObjects!
        
        let obj = objects[sourceIndexPath.row]
        objects.remove(at: sourceIndexPath.item)
        objects.insert(obj, at: destinationIndexPath.item)
                
        var i = 0
        for obj in objects {
            obj.position = Int32(i) as NSNumber?
            i += 1
        }
        
        ad.saveContext()
        tableView.reloadData()
    }
    func editBtnPressed(sender: UIBarButtonItem) {
        
        
        if self.tableView.isEditing == true {
            self.tableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        } else {
            self.tableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }

    }
    //turns on editing mode
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(isEditing, animated: true)
    }
    
    //these two func get rid of the default delete button that appears when in the editting mode
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    //5 Lines of code send to me by GOD!!!!!!
    //tells me when this controller is being currentlly viewed so that i can refresh it
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print("VC appears")
        attemptFetch()
        tableView.reloadData()
        ad.saveContext()
    }
}


