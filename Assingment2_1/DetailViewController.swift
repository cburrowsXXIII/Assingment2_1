//
//  DetailViewController.swift
//  Assingment2_1
//
//  Created by Christopher Burrows on 9/4/19.
//  Copyright © 2019 Christopher Burrows. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate{
    var copyOfOriginalItem: Place?
    var detail: Place?
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var longField: UITextField!
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let name = nameField {
                name.text = detail.name
            }
            if let address = addressField {
                address.text = detail.address
            }
            if let lat = latField {
                if detail.latitude > 0.0{
                    lat.text = String(detail.latitude)
                } else {
                    lat.text = ""
                }
            }
            if let long = longField {
                if detail.longitude > 0.0{
                    long.text = String(detail.longitude)
                } else {
                    long.text = ""
                }
            }
            guard copyOfOriginalItem == nil else {
                return
            }
            copyOfOriginalItem = Place(name: detail.name, address: detail.name, latitude: detail.latitude, longitude: detail.longitude)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameField.delegate = self
        addressField.delegate = self
        latField.delegate = self
        longField.delegate  = self
        configureView()
        //Keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        //Stop listening
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveInModel()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        if UIDevice.current.orientation.isLandscape {
            if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillShowNotification {
                view.frame.origin.y = -20
            } else {
                view.frame.origin.y = 0
            }
        }
        
    }
    
    func textFieldShouldReturn(_ nameField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
    
    var detailItem: Place? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func saveInModel() {
        detail?.name = nameField.text ?? ""
        
        
        
    }
    


}

