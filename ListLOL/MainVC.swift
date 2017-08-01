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
        
        //generateTestData()
        attemptFetch()
        
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
        
        //performSegue(withIdentifier: "ItemsDetailsVC", sender: myCell)
        
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
        let dateSort = NSSortDescriptor(key: "created", ascending: false)

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

        fetchRequest.sortDescriptors = [dateSort]
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
    
    
}


func generateTestData(){
    
    let item1 = Item(context: context)
    item1.title = "chillax man u deserve it!"
    
    let item2 = Item(context: context)
    item2.title = "Dont forget to rest"
    
    let item3 = Item(context: context)
    item3.title = "have some great food and stay highdrated as always"
    
    ad.saveContext()
}

