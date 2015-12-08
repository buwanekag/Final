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
        
      //  var nameDisplay = ""
        
       // var supplyDict = Dictionary<String, String>()
        
//        for nameID in dataManager.suppliesArray{
//            supplyDict[nameID.supplyID!] = nameID.supplyName!
//        }
        
//        for requestId in request.requestSupplyID{
//            nameDisplay += supplyDict[requestId] + "\n"
//        }
        
        cell.requestNameView.text = request.requestSupplyName!
        //cell.requestNameLabel.text = request.requestSupplyName
        
        cell.requestDateLabel.text = cloudManager.formatStringFromDate(request.createdDate!)
        
        
        return cell
        
    }
    
    //MARK: - NOTIFICATION CENTRE
    
    
    func newDataReceived() {
//        if self.refreshControl.refreshing
//        {
//            self.refreshControl.endRefreshing()
//        }
//        
        requestsList.reloadData()
      //  self.tableView?.reloadData()
    }
        
        
       // requestsList.reloadData()
  //  }
    
    func refreshTableView() {
        cloudManager.getRequestListFromServer()
    }
    
    
    
    
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TURN THIS BACK ON!!!!!
//        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        self.requestsList.addSubview(refreshControl)
//        self.refreshTableView()
//        
        
       cloudManager.getSuppliesListFromServer()
        cloudManager.getRequestListFromServer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDataReceived", name: "receivedDataFromServer", object: nil)
        
        

       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
