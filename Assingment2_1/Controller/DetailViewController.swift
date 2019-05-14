//
//  DetailViewController.swift
//  Assingment2_1
//
//  Created by Christopher Burrows on 9/4/19.
//  Copyright © 2019 Christopher Burrows. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DetailViewController: UITableViewController, UITextFieldDelegate{
    var copyOfOriginalItem: Place?
    var detail: Place?
    var new: Place?
    var newItem = false
    var cancel = false
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var longField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    ///Function configures the detail view when called upon by populating the inputs and running mapView.
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detail {
            var latBack:Double = 0.0
            var longBack: Double = 0.0
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
                    latBack = detail.latitude
                    lat.text = String(detail.latitude)
                } else {
                    lat.text = ""
                }
            }
            if let long = longField {
                if detail.longitude > 0.0{
                    longBack = detail.longitude
                    long.text = String(detail.longitude)
                    
                } else {
                    long.text = ""
                }
            }
            if latBack != 0.0 && longBack != 0.0 {
                mapLookUp(latitude: latBack, longitude: longBack)
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
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    ///Function controls the adjustment of the view when the keyboard would cover an input.
    @objc func keyboardWillChange(notification: Notification) {
        if UIDevice.current.orientation.isLandscape {
            if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillShowNotification {
                view.frame.origin.y = -18
            } else {
                view.frame.origin.y = 0
            }
        }
        
    }
    
    func textFieldShouldReturn(_ sender: UITextField) -> Bool {
        switch sender {
        case nameField:
            sender.resignFirstResponder()
            saveInModel()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        case addressField:
            sender.resignFirstResponder()
            if latField.text == ""{
                forwardGeo()
            } else {
                addressField.text = detail?.address
                saveInModel()
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        case latField:
            sender.resignFirstResponder()
            if longField.text != "" && addressField.text == ""{
                reverseGeo()
            } else {
                addressField.text = detail?.address
                saveInModel()
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        case longField:
            sender.resignFirstResponder()
            if latField.text != "" && addressField.text == ""{
                reverseGeo()
            } else {
                addressField.text = detail?.address
                saveInModel()
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        default:
            break
        }
        return true
    }
    
    
    ///Action function that cancels an item editing.
    @IBAction func cancelButtonPressed(_ sender: Any) {
        guard let copy = copyOfOriginalItem else { return }
        detail?.name = copy.name
        detail?.address = copy.address
        detail?.latitude = copy.latitude
        detail?.longitude = copy.longitude
        if newItem {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancelNew"), object: nil)
            newItem = false
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancel"), object: nil)
        }
        cancel = true
        configureView()
        
        

    }
    ///Function that saves any changes made into the current item.
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
                //print("This :\(longSave)")
                if let numLong = Double(longSave) {
                    detail.longitude = numLong
                }
            }
        }
        newItem = false
        
    }
    
    ///Geolocation function that uses CLGeocoder to perform forward geolocation.
    func forwardGeo() {
        let geo = CLGeocoder()
        let address = addressField.text ?? ""
        var latitude = ""
        var longitude = ""
        geo.geocodeAddressString(address) {
            guard let placeMarks = $0 else {
                print("Got error: \(String(describing: $1))")
                return
            }
            print("Got \($0?.count ?? 0) elements:")
            for placeMark in placeMarks {
                guard let location = placeMark.location else {
                    continue
                }
                let latLoc = location.coordinate.latitude
                let longLoc = location.coordinate.longitude
                latitude = "\(location.coordinate.latitude)"
                longitude = "\(location.coordinate.longitude)"
                //print(latitude, longitude)
                self.latField.text = latitude
                self.longField.text = longitude
                self.saveInModel()
                self.mapLookUp(latitude: latLoc, longitude: longLoc)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "store"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            }
        }
    }
    
    ///Geolocation function that uses CLGeocoder to perform reverse geolocation.
    func reverseGeo(){
        let geo = CLGeocoder()
        var numLat = 0.0
        var numLong = 0.0
        if let latSearch = latField?.text {
            if let test = Double(latSearch){
                numLat = test
            }
        }
        if let longSearch = longField?.text {
            if let test = Double(longSearch){
                numLong = test
            }
        }
        let location = CLLocation(latitude: numLat, longitude: numLong)
        geo.reverseGeocodeLocation(location) {
            guard let places = $0 else {
                print("Got error \(String(describing: $1))")
                return
            }
            for place in places {
                guard let name = place.name else {
                    print("Got no name")
                    continue
                }
                let add = "\(name), \(place.locality ?? ""), \(place.administrativeArea ?? "N/A"), \(place.country ?? "N/A"), \(place.postalCode ?? "N/A")"
                self.addressField.text = add
                self.mapLookUp(latitude: numLat, longitude: numLong)
                self.saveInModel()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "store"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                
            }
        }
    }
    
    ///Performs all of the map functionality. Sets a region to display using coordinates in the parameters. Resets and adds a pin to that location. Latitude and Longitude are doubles.
    func mapLookUp(latitude: Double, longitude: Double){
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        self.mapView.setRegion(region, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = self.addressField.text
            annotation.subtitle = "\(coordinates.latitude), \(coordinates.longitude)"
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            self.mapView.addAnnotation(annotation)
        }
    }
    

}

