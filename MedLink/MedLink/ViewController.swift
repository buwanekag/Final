//
//  ViewController.swift
//  MedLink
//
//  Created by Buwaneka Galpoththawela on 11/13/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var cloudManager = CloudManager.sharedInstance
    var networkManager = NetworkManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    var refreshControl = UIRefreshControl()
    
    
    @IBOutlet var requestsList :UITableView!
    
    
        
    
    
    
    
    //MARK:- TABLEVIEW METHOD
    // Test
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.requestsArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RequestsTableViewCell
        
        let request = dataManager.requestsArray[indexPath.row]
        if let response = request.toResponseData?.allObjects.first as? ResponseData {
           // cell.requestNameLabel.text = response.requestSupplyID
            cell.responseTypeLabel.text = response.responseType
        } else {
           // cell.requestNameLabel.text = ""
            cell.responseTypeLabel.text = ""
        }
        
             
        cell.requestNameView.text = request.requestSupplyName!
        //cell.requestNameLabel.text = request.requestSupplyName
        
        cell.responseDateLabel.text = cloudManager.formatStringFromDate(request.createdDate!)
        
        
        return cell
        
    }
    
    //MARK: - NOTIFICATION CENTRE
    
    
    func newDataReceived() {
       requestsList.reloadData()
          }
        
        
    
//    func refreshTableView() {
//        cloudManager.getRequestListFromServer()
//        let refresh = cloudManager.refreshControl
//        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refresh.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//       // self.requestsList.addSubview(refresh)
//        
//       // cloudManager.getRequestListFromServer()
//    }
    
    
    
    
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TURN THIS BACK ON!!!!!
        //refreshTableView()
        
       cloudManager.getSuppliesListFromServer()
        dataManager.suppliesArray = dataManager.fetchSupplies()!
        cloudManager.getRequestListFromServer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDataReceived", name: "receivedDataFromServer", object: nil)
        
        

       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //refreshTableView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

