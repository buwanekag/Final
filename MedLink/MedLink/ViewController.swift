//
//  ViewController.swift
//  MedLink
//
//  Created by Buwaneka Galpoththawela on 11/13/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var cloudManager = CloudManager.sharedInstance
    var networkManager = NetworkManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    var refreshControl = UIRefreshControl()
    
    
    @IBOutlet var requestsList :UITableView!
    
    
    //MARK - SECTIONS METHOD
    
    
    var sectionsArray = [NSDate]()
    
    func createSectionArray() ->[NSDate] {
        var categorySet = Set<NSDate>()
        for request in dataManager.requestsArray {
            
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day, .Month, .Year], fromDate: request.createdDate!)
            let noTimeDate = calendar.dateFromComponents(components)!
            
            categorySet.insert(noTimeDate)
            
        }
        let categoryArray = Array(categorySet)
        let sortedCategoryArray = categoryArray.sort({$0.compare($1) == .OrderedAscending})
        return sortedCategoryArray
    }
    
    
    func filterDateByCategory(date:NSDate) ->[RequestsData] {
        let filteredRequests = dataManager.requestsArray.filter({($0.createdDate) == date})
        return filteredRequests
    }
    
    
    
    
    //MARK:- TABLEVIEW METHOD
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionsArray.count
    }
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dataManager.requestsArray.count
        return filterDateByCategory(sectionsArray[section]).count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RequestsTableViewCell
        
        let request = dataManager.requestsArray[indexPath.row]
        if let response = request.toResponseData?.allObjects.first as? ResponseData {
                cell.responseTypeLabel.text = response.responseType
        } else {
        
            cell.responseTypeLabel.text = ""
        }
        
             
        //cell.requestNameView.text = request.requestSupplyName!
        //cell.requestNameLabel.text = request.requestSupplyName!
        
        cell.requestNameLabel.text = String(filterDateByCategory(sectionsArray[indexPath.section]))
        
       // cell.responseDateLabel.text = cloudManager.formatStringFromDate(request.createdDate!)
       // let filter = filterDateByCategory(sectionsArray[indexPath.section])
       // cell.responseDateLabel.text = ("\(formatStringFromDate(request.createdDate!))")
        
       // cell.responseDateLabel.text! = cloudManager.formatStringFromDate(request.createdDate!)
       
        return cell
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        let stringDate = formatter.stringFromDate(sectionsArray[section])
        
        return stringDate
    }
    
//    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return "count:\(sectionsArray.count)"
//    }
//    
    //MARK: - NOTIFICATION CENTRE
    
    
    func newDataReceived() {
        sectionsArray = createSectionArray()
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
        
     
        
        
       cloudManager.getSuppliesListFromServer()
        dataManager.suppliesArray = dataManager.fetchSupplies()!
        cloudManager.getRequestListFromServer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDataReceived", name: "receivedDataFromServer", object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDataReceived", name: "gotCoreData", object: nil)
        
        

       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //refreshTableView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

