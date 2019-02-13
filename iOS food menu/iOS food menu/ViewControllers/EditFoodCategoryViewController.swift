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
        guard let name = nameTextField.text, name != "" else {
            self.presentAlertView(title: "Please enter a name")
            return
        }
        var newImageUrl: String? = nil
        if let image = imageView.image {
            filePathManager.delete(name: name)
            newImageUrl = filePathManager.save(image: image, name: name, type: "FoodCategories")
        }
        if isEdit {
            if let foodCategory = self.foodCategory {
                foodCategoryDataManager.updateFoodCategory(foodCategory: foodCategory, name: name, imageUrl: newImageUrl)
            }
        } else {
            foodCategoryDataManager.createFoodCategory(name: name, imageUrl: newImageUrl)
        }
        self.navigationController?.popViewController(animated: true)
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
