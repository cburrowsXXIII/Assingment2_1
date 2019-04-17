//
//  MasterViewController.swift
//  Assingment2_1
//
//  Created by Christopher Burrows on 9/4/19.
//  Copyright © 2019 Christopher Burrows. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {


    var detailViewController: DetailViewController?
    var objects = [Place]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelPressed), name: NSNotification.Name(rawValue: "cancel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelNewPressed), name: NSNotification.Name(rawValue: "cancelNew"), object: nil)
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        let n = objects.count
        objects.append(Place(name: "New Place", address: "", latitude: -100.0, longitude: 0.0))
        let indexPath = IndexPath(row: n, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    @objc
    func loadList(){
        self.tableView.reloadData()
    }
    
    func backPressed() {
        tableView.reloadData()
        
    }
    @objc
    func cancelNewPressed() {
        objects.removeLast()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
        print("CancelNew")
    }
    @objc
    func cancelPressed() {
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
        print("Cancel")
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let indexPath: IndexPath
            if let i = sender as? IndexPath {
                indexPath = i
            } else if let cell = sender as? UITableViewCell,
                let i = tableView.indexPath(for: cell) {
                indexPath = i
            } else { return }
            let object = objects[indexPath.row]
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detail = object
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = objects[indexPath.row]
        cell.textLabel?.text = object.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    

    
}

