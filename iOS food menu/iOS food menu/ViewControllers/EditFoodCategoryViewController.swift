//
//  EditFoodCategoryViewController.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-11.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit

class EditFoodCategoryViewController: UIViewController {

    let foodCategoryDataManager = FoodCategoryDataManager()
    
    let filePathManager = FilePathManager()
    
    var isEdit: Bool = false
    
    var foodCategory: FoodCategory?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        self.presentImagePicker()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let newName = nameTextField.text, newName != "" else {
            self.presentAlertView(title: "Please enter a name")
            return
        }
        
        isEdit ? editFoodCategoryHandler(newName: newName) : addFoodCategoryHandler(newName: newName)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func editFoodCategoryHandler(newName: String) {
        guard let foodCategory = self.foodCategory else {
            fatalError()
        }
        
        var newImageUrl: String? = nil
        if let image = imageView.image {
            filePathManager.tryDelete(hashValue: foodCategory.hashValue, entityType: .foodCategory)
            newImageUrl = filePathManager.save(image: image, hashValue: foodCategory.hashValue, entityType: .foodCategory)
        }
        foodCategoryDataManager.updateFoodCategory(foodCategory: foodCategory, name: newName, imageUrl: newImageUrl)
    }
    
    private func addFoodCategoryHandler(newName: String) {
        foodCategoryDataManager.createFoodCategory(name: newName, imageUrl: nil) { (newFoodCategory) in
            if let image = self.imageView.image, let newFoodCategory = newFoodCategory {
                let newImageUrl = self.filePathManager.save(image: image, hashValue: newFoodCategory.hashValue, entityType: .foodCategory)
                self.foodCategoryDataManager.updateFoodCategory(foodCategory: newFoodCategory, name: newName, imageUrl: newImageUrl)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let foodCategory = self.foodCategory {
            nameTextField.text = foodCategory.name
            if let imageUrl = foodCategory.imageURL, filePathManager.fileManager.fileExists(atPath: imageUrl), let fileContents = UIImage(contentsOfFile: imageUrl) {
                imageView.image = fileContents
            }
        }
    }
}

extension EditFoodCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
