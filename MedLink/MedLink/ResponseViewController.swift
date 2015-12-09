//
//  ResponseViewController.swift
//  MedLink
//
//  Created by Buwaneka Galpoththawela on 12/5/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit

class ResponseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var cloudManager = CloudManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    var selectedRequestsArray = [Bool]()
   // var selectedItems = [String:SuppliesData]()
    
    @IBOutlet var requestList: UITableView!
    @IBOutlet var requestsDisplay: UITextView!
    
    
    
    //MARK: - TABLE VIEW METHOD 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.requestsArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
       
       
        if selectedRequestsArray[indexPath.row] {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        
        let request = dataManager.requestsArray[indexPath.row]
        cell.textLabel?.text = request.requestSupplyName!
       // cell.responseSupplyDisplay.text! = request.requestSupplyName!
        
        
        return cell
        
    }
    
    func displaySelections() {
        var selections = ""
        var index = 0
        for supplySelected in selectedRequestsArray {
            if supplySelected {
                selections = selections + dataManager.requestsArray[index].requestSupplyName! + "\n"
            }
            index++
        }
        
        requestsDisplay.text! = selections
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let row = indexPath.row
        print("Select \(row)")
        
        //  selectedItems.append(dataManager.suppliesArray[indexPath.row])
        
        selectedRequestsArray[row] = !selectedRequestsArray[row]
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        displaySelections()
        
    }
    
    
    
    
    
    
    //MARK: - INTERACTIVE METHOD
    
    @IBAction func submitButtonPressed(sender:UIBarButtonItem){
        
        
        var supplyIds = [String]()
        var index = 0
        for supplySelected in selectedRequestsArray {
            if supplySelected {
                supplyIds.append(dataManager.requestsArray[index].requestSupplyID!+"\n")
                
                print("suppies\(supplyIds)")
            }
            index++
        }
        
        
        cloudManager.sendRequestToServer(requestsDisplay.text!, supplyIds: supplyIds)
    }
    
    
    
    


    
    
    
    
    
    
    
    
    //MARK: - LIFE CYCLE METHOD

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedRequestsArray.removeAll()
        for _ in dataManager.requestsArray {
            selectedRequestsArray.append(false)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
