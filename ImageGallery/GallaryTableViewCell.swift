//
//  GallaryTableViewCell.swift
//  ImageGallery
//
//  Created by Саша Восколович on 14.09.2023.
//

import UIKit

class GallaryTableViewCell: UITableViewCell {

  
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(editingBegin))
            tap.numberOfTapsRequired = 2
            addGestureRecognizer(tap)
            nameTextField.delegate = self
        }
    }
    
    
    @objc func editingBegin() {
        nameTextField.isEnabled = true
        nameTextField.becomeFirstResponder()
    }
        
    var registrationHandler: (() -> Void)?
}



extension GallaryTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.isEnabled = false
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        registrationHandler?()
    }
}
