//
//  ImgGalleryVC.swift
//  ListLOL
//
//  Created by Michal Chorobik on 2017-07-27.
//  Copyright © 2017 Michal Chorobik. All rights reserved.
//

import UIKit

class ImgGalleryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var collection: UICollectionView!
    
    var imagePicker: UIImagePickerController!
    
    let array:[String] = ["abc","1","2","3","4","6","7","11","12","13","14"]
    
    var itemEdit: Item?
    var item: Item!

    //here i retrive the image choosen in the func above and assign it to the imgg var created below
    var img: UIImage! = UIImage(named: "abc.jpg")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if(itemEdit != nil){
            itemEdit?.image1 = UIImage(named: "default2.jpg")
        }
        
        //the back button is just an arro without any text beside it
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
    }
    
    //determine how many
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    //populate the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GalleryCell{
            
            if(indexPath.row == array.count - 1){
                cell.thumbImg.image = UIImage(named: "add-square3.jpg")
            }else{
                cell.thumbImg.image = UIImage(named: array[indexPath.row] + ".jpg")
            }
            
            return cell
        }else{
            return UICollectionViewCell()
        }
        
    }
    
    
    /**********************************picking the image from the iphone******************************************************************/
    
    //when selected we are presented the iphone photo gallery picker
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(indexPath.row == array.count - 1){
            present(imagePicker, animated: true, completion: nil)
        }else{
            item = itemEdit
            item.image1 = UIImage(named: array[indexPath.row] + ".jpg")
            ad.saveContext()
            _ = navigationController?.popViewController(animated: true)
        }
        
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            item = itemEdit
            item.image1 = img
            ad.saveContext()
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
        //performSegue(withIdentifier: "ItemsDetailsVC", sender: self)
        
        _ = navigationController?.popViewController(animated: false)

    }
    

    /****************************************************************************************************/
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 65, height: 65)
    }
    //status bar is hidden
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
