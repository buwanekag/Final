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
     @IBOutlet var logoDisplay :UIImageView!
    
    
    //MARK: - SECTIONS METHOD
    
    
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
    
    
    func filterRequestDataByDate(date:NSDate) ->[RequestsData] {
        let filteredRequests = dataManager.requestsArray.filter({
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day, .Month, .Year], fromDate: $0.createdDate!)
            let noTimeDate = calendar.dateFromComponents(components)!
            print("CD:\(noTimeDate) D:\(date)")
            return noTimeDate == date
        })
        return filteredRequests
    }
    
    
    
    
    //MARK:- TABLEVIEW METHOD
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("Sections:\(sectionsArray.count)")
        return sectionsArray.count
    }
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dataManager.requestsArray.count
        let count = filterRequestDataByDate(sectionsArray[section]).count
        print("Section \(section):\(count)")
        return count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RequestsTableViewCell
        
        let currentReqeustData = filterRequestDataByDate(sectionsArray[indexPath.section])[indexPath.row]
        
        if let currentResponseData = currentReqeustData.toResponseData?.allObjects.last as? ResponseData {
            cell.responseTypeLabel.text = currentResponseData.responseType
        } else {
            
            cell.responseTypeLabel.text = ""
        }

        cell.requestNameLabel.text = currentReqeustData.requestSupplyName
      
        
              
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
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let returnedView = UIView(frame: CGRectMake(0, 0, 40, 10)) //set these values as necessary
//        returnedView.backgroundColor = UIColor.lightGrayColor()
//        
////        var label = UILabel(frame: CGRectMake(labelX, labelY, labelWidth, labelHeight))
////        label.text = self.sectionHeaderTitleArray[section]
////        returnedView.addSubview(label)
//        
//        return returnedView
//    }
   
    
    //MARK: - NOTIFICATION CENTRE
    
    
    func newDataReceived() {
        sectionsArray = createSectionArray()
        requestsList.reloadData()
        //self.refreshControl.endRefreshing()
    }
    
    
    
    func refreshData() {
         cloudManager.getRequestListFromServer()
        self.refreshControl.endRefreshing()
    }
        
    
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
     
        
        
        cloudManager.getSuppliesListFromServer()
        dataManager.suppliesArray = dataManager.fetchSupplies()!
        cloudManager.getRequestListFromServer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDataReceived", name: "receivedDataFromServer", object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDataReceived", name:
            "gotCoreData", object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        self.requestsList.addSubview(refreshControl)
        logoDisplay.image = UIImage(named: "pcLogo")
        

       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

