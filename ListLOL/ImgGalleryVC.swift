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
    
    let array:[String] = ["abc","bg","imagePick","bg","abc","imagePick","abc","imagePick","bg"]
    
    
    //here i retrive the image choosen in the func above and assign it to the imgg var created below
    var imgg: UIImage! = UIImage(named: "abc.jpg")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
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
            cell.thumbImg.image = UIImage(named: array[indexPath.row] + ".jpg")
            return cell
        }else{
            return UICollectionViewCell()
        }
        
    }
    
    
    /**********************************picking the image from the iphone******************************************************************/
    
    //when selected we are presented the iphone photo gallery picker
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imgg = img
            imagePicker.dismiss(animated: true, completion: nil)
            print("1111111111")
        }
        print("2222222222")
        
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
    


}
