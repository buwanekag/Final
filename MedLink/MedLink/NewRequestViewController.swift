//
//  NewRequestViewController.swift
//  MedLink
//
//  Created by Buwaneka Galpoththawela on 11/30/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit

class NewRequestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var cloudManager = CloudManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    var selectedSupplyArray = [Bool]()
    var selectedItems = [String:SuppliesData]()
    
    @IBOutlet var supplyList: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var selectedSupplyDisplay :UITextView!
    
   
    //MARK: - TABLEVIEW METHOD
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.suppliesArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        return populateCell(tableView, indexPath: indexPath)
        
    }
    
    func populateCell(tableView: UITableView, indexPath:NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if selectedSupplyArray[indexPath.row] {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        let displayUser = dataManager.suppliesArray[indexPath.row]
        cell.textLabel?.text = displayUser.supplyName
        return cell
        
        
    }
    
    func displaySelections() {
        var selections = ""
        var index = 0
        for supplySelected in selectedSupplyArray {
            if supplySelected {
                selections = selections + dataManager.suppliesArray[index].supplyName!+"\n"
            }
            index++
        }
        
        selectedSupplyDisplay.text! = selections
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let row = indexPath.row
        print("Select \(row)")
        
        //  selectedItems.append(dataManager.suppliesArray[indexPath.row])
        
        selectedSupplyArray[row] = !selectedSupplyArray[row]
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        displaySelections()
        
    }
    
    
    
    
    
    
    
    
    
    //MARK: - INTERACTIVE METHOD
    
    @IBAction func submitButtonPressed(sender:UIBarButtonItem){
        
        
        var supplyIds = [String]()
        var index = 0
        for supplySelected in selectedSupplyArray {
            if supplySelected {
                supplyIds.append(dataManager.suppliesArray[index].supplyID!)
                
                print("suppies\(supplyIds)")
            }
            index++
        }
        
        
        cloudManager.sendRequestToServer(messageTextField.text!, supplyIds: supplyIds)
        messageTextField.resignFirstResponder()
    }
    
    
    
    
    
    //MARK: - NOTIFICATION CENTER
    
    func newDataReceived() {
        supplyList.reloadData()
        
    }
    
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDataReceived", name: "receivedSupplyDataFromServer", object: nil)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedSupplyArray.removeAll()
        for _ in dataManager.suppliesArray {
            selectedSupplyArray.append(false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
