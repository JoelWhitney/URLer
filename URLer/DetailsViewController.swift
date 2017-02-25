//
//  DetailsViewController.swift
//  URLer
//
//  Created by Joel Whitney on 2/22/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
//    @IBOutlet weak var nameField: UITextField!
//    @IBOutlet weak var serialField: UITextField!
//    @IBOutlet weak var valueField: UITextField!
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var imageView: UIImageView!
//    
//    @IBAction func takePicture(_ sender: UIBarButtonItem) {
//        
//        let imagePicker = UIImagePickerController()
//        
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//        } else {
//            imagePicker.sourceType = .photoLibrary
//        }
//        imagePicker.delegate = self
//        present(imagePicker, animated: true, completion: nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [String: Any]) {
//        // Get picked image from info dictionary
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        
//        imageStore.setImage(image, forKey: item.itemKey)
//        // Put that image on the screen in the image view
//        imageView.image = image
//        // Take image picker off the screen -
//        // you must call this dismiss method
//        dismiss(animated: true, completion: nil)
//    }
//    
//    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
//        view.endEditing(true)
//    }
//    
//    var item: Item! {
//        didSet {
//            navigationItem.title = item.name
//        }
//    }
//    
//    var imageStore: ImageStore!
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    let numberFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.minimumFractionDigits = 2
//        formatter.maximumFractionDigits = 2
//        return formatter
//    }()
//    
//    let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        return formatter
//    }()
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        nameField.text = item.name
//        serialField.text = item.serialNumber
//        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
//        dateLabel.text = dateFormatter.string(from: item.dateCreated)
//        
//        let key = item.itemKey
//        let imageToDisplay = imageStore.image(forKey: key)
//        imageView.image = imageToDisplay
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        view.endEditing(true)
//        
//        item.name = nameField.text ?? ""
//        item.serialNumber = serialField.text
//        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText) {
//            item.valueInDollars = value.intValue
//        } else {
//            item.valueInDollars = 0
//        }
//    }
}

