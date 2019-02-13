//
//  EditFoodItemViewController.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-12.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit

class EditFoodItemViewController: UIViewController {
    
    let foodItemDataManager = FoodItemDataManager()
    
    let filePathManager = FilePathManager()
    
    var isEdit: Bool = false
    
    var foodItem: FoodItem?

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextField: CurrencyTextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        self.presentImagePicker()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text, name != "" else {
            self.presentAlertView(title: "Please enter a name")
            return
        }
        
        guard let price = priceTextField.text, price != "" else {
            self.presentAlertView(title: "Please enter a valid price")
            return
        }
        
        var newImageUrl: String? = nil
        if let image = imageView.image {
            filePathManager.delete(name: name)
            newImageUrl = filePathManager.save(image: image, name: name)
        }
        if isEdit {
            if let foodItem = self.foodItem {
                foodItemDataManager.updateFoodItem(foodItem: foodItem, name: name, imageUrl: newImageUrl, price: price)
            }
        } else {
            foodItemDataManager.createFoodItem(name: name, imageUrl: newImageUrl, price: price)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let foodItem = self.foodItem {
            nameTextField.text = foodItem.name
            priceTextField.text = foodItem.price
            if let imageUrl = foodItem.imageURL, filePathManager.fileManager.fileExists(atPath: imageUrl), let fileContents = UIImage(contentsOfFile: imageUrl) {
                imageView.image = fileContents
            }
        }
    }
}

extension EditFoodItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
    }
}
