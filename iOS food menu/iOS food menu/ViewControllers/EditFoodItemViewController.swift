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
    
    var foodCategory: FoodCategory!

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextField: CurrencyTextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        self.presentImagePicker()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let newName = nameTextField.text, newName != "" else {
            self.presentAlertView(title: "Please enter a name")
            return
        }
        
        guard let price = priceTextField.text, price != "" else {
            self.presentAlertView(title: "Please enter a valid price")
            return
        }
        
        isEdit ? editFoodItemHandler(newName: newName, price: price) : addFoodItemHandler(newName: newName, price: price)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func editFoodItemHandler(newName: String, price: String) {
        guard let foodItem = self.foodItem else {
            fatalError()
        }
        var newImageUrl: String? = nil
        if let image = imageView.image {
            filePathManager.tryDelete(hashValue: foodItem.hashValue, entityType: .foodItem)
            newImageUrl = filePathManager.save(image: image, hashValue: foodItem.hashValue, entityType: .foodItem)
        }
        foodItemDataManager.updateFoodItem(foodItem: foodItem, name: newName, imageUrl: newImageUrl, price: price)
        foodItemDataManager.assignFoodItem(foodItem, to: foodCategory)
    }
    
    private func addFoodItemHandler(newName: String, price: String) {
        var newImageUrl: String? = nil
        if let image = imageView.image {
            newImageUrl = filePathManager.save(image: image, hashValue: foodItem.hashValue, entityType: .foodItem)
        }
        foodItemDataManager.createFoodItem(name: newName, imageUrl: newImageUrl, price: price) { (newFoodItem) in
            if let newFoodItem = newFoodItem {
                self.foodItemDataManager.assignFoodItem(newFoodItem, to: self.foodCategory)
            }
        }
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
