//
//  DetailViewController.swift
//  Assingment2_1
//
//  Created by Christopher Burrows on 9/4/19.
//  Copyright © 2019 Christopher Burrows. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func didDismissDetail(sender:DetailViewController)
}


class DetailViewController: UIViewController, UITextFieldDelegate{
    var copyOfOriginalItem: Place?
    var detail: Place?
    var newItem = false
    var cancel = false
    
    weak var delegate: DetailViewControllerDelegate?
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var longField: UITextField!
    
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detail {
            if let name = nameField {
                if detail.name != "New Place"{
                    name.text = detail.name
                } else {
                    newItem = true
                }
            }
            if let address = addressField {
                address.text = detail.address
            }
            if let lat = latField {
                if detail.latitude > -100.0{
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
            copyOfOriginalItem = Place(name: detail.name, address: detail.address, latitude: detail.latitude, longitude: detail.longitude)
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
    
    private func textFieldDidBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == longField {
            return true
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        if UIDevice.current.orientation.isLandscape {
            if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillShowNotification {
                view.frame.origin.y = -18
            } else {
                view.frame.origin.y = 0
            }
        }
        
    }
    
    func textFieldShouldReturn(_ nameField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        saveInModel()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        //delegate?.backPressed()
        return true
    }
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        guard let copy = copyOfOriginalItem else { return }
        if newItem{
            print(Storage.shared.objects)
            Storage.shared.objects.removeLast()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        } else{
            detail?.name = copy.name
            detail?.address = copy.address
            detail?.latitude = copy.latitude
            detail?.longitude = copy.longitude
            configureView()
        }
        delegate?.didDismissDetail(sender: self)
               
    }
    
    func saveInModel() {
        if let detail = detail {
            if let nameSave = nameField {
                detail.name = nameSave.text ?? "Fail"
            }
            if let addSave = addressField {
                detail.address = addSave.text ?? "Fail"
            }
            if let latSave = latField?.text {
                if let numLat = Double(latSave) {
                    detail.latitude = numLat
                }
            }
            if let longSave = longField?.text {
                if let numLong = Double(longSave) {
                    detail.longitude = numLong
                }
            }
        }
        
    }
    
    
    


}

