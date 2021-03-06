//
//  CloudManager.swift
//  MedLink
//
//  Created by Buwaneka Galpoththawela on 11/29/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit
import HMACSigner
import CoreData

class CloudManager: NSObject {
    
    static let sharedInstance = CloudManager()
    var dataManager = DataManager.sharedInstance
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjetContext : NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var refreshControl = UIRefreshControl()
    
    
    var baseUrlString = "medlink-staging.herokuapp.com"
    
   
    
    //MARK: - CLEAR CORE DATA
    
    func removeAllRequests() {
        if let toDeleteArray = dataManager.fetchRequests(){
            for request in toDeleteArray {
                managedObjetContext.deleteObject(request)
            }
            appDelegate.saveContext()
        }
    }
    func removeAllResponses() {
        if let toDeleteArray = dataManager.fetchResponses(){
            for requestSupply in toDeleteArray {
                managedObjetContext.deleteObject(requestSupply)
            }
            appDelegate.saveContext()
        }
    }
    func removeAllSuppliess() {
        if let toDeleteArray = dataManager.fetchSupplies(){
            for supply in toDeleteArray {
                managedObjetContext.deleteObject(supply)
            }
            appDelegate.saveContext()
        }
    }
    
    
    
    
    
    
    //MARK: - SUPPLY LIST POPULATION METHOD
    
    
    func getSuppliesListFromServer() {
        print("getting master supply list")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        defer {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        let url = NSURL(string: "https://\(baseUrlString)/api/v1/supplies")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "GET"
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.signWithAccessIdentifier("2376", andSecret: "HLHSDDp+95IqeCuAjCslZRqRcPdnRXFd55W904lamDMQh9pa+UIrNRz+hiPpg5u7FKKPF5GjQPEPSWYbzbGbpw==")
        
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if data != nil {
                             // print("Data\(data)")
                self.parseSuppliesData(data!)
            } else {
                print("No Data")
            }
        }
       
        task.resume()
        
    }
    
    func parseSuppliesData(data:NSData){
        removeAllSuppliess()
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            
            let tempDictArray = jsonResult.objectForKey("supplies") as! [NSDictionary]
            dataManager.suppliesArray.removeAll()
            
            print("result\(jsonResult)")
            
            
            for suppliesDict in tempDictArray {
                
                let entityDescription :NSEntityDescription! = NSEntityDescription.entityForName("SuppliesData", inManagedObjectContext: managedObjetContext)
                
                let currentSupply:SuppliesData! = SuppliesData(entity: entityDescription, insertIntoManagedObjectContext: managedObjetContext)
                //print("supplylist\(suppliesDict)")
                currentSupply.supplyID = String(suppliesDict.objectForKey("id") as! Int!)
                currentSupply.supplyName = suppliesDict.objectForKey("name") as? String
                currentSupply.supplyShortCode = suppliesDict.objectForKey("shortcode") as? String
                
                
            }
            appDelegate.saveContext()
            dataManager.suppliesArray = dataManager.fetchSupplies()!
            print("Master supply list count \(dataManager.suppliesArray.count)")
            //print("supplies\(dataManager.suppliesArray)")

            dispatch_async(dispatch_get_main_queue()){
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedSupplyDataFromServer", object: nil))
                
          //self.dataManager.suppliesArray = self.dataManager.fetchSupplies()!
           }
        } catch {
            print("JSON Parsing Error")
        }
        
    }
    
    
    
    //MARK: - REQUEST LIST POPULATION METHOD
    
    func getRequestListFromServer() {
        
//        dataManager.requestsArray = dataManager.fetchRequests()!
//        dataManager.responseArray = dataManager.fetchResponses()!
//        
//        if (!dataManager.requestsArray.isEmpty && !dataManager.responseArray.isEmpty) {
//            return
//        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        defer {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            dataManager.requestsArray = dataManager.fetchRequests()!
            dataManager.responseArray = dataManager.fetchResponses()!
            
        }
        
                 let url = NSURL(string: "https://\(baseUrlString)/api/v1/requests")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "GET"
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.signWithAccessIdentifier("2376", andSecret: "HLHSDDp+95IqeCuAjCslZRqRcPdnRXFd55W904lamDMQh9pa+UIrNRz+hiPpg5u7FKKPF5GjQPEPSWYbzbGbpw==")
        
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if data != nil {
                if self.refreshControl.refreshing
                        {
                            self.refreshControl.endRefreshing()
                        }

                
                               //print("Data\(data)")
                self.parseRequestsData(data!)
            } else {
                print("No Data")
            }
        }
        
        
      
        task.resume()
        
    }
    
    func findSupplyWithID(supplyID: String) -> SuppliesData? {
        // if Statement to handle a nil value
        let supply = dataManager.suppliesArray.filter({$0.supplyID == supplyID}).first
        return supply
    }
    
    func parseRequestsData(data:NSData){
        removeAllRequests()
        removeAllResponses()
      
        //print("Supplies Array Count:\(dataManager.suppliesArray.count)")
        //for junk in dataManager.suppliesArray {
          //  print("Supply: \(junk.supplyID) \(junk.supplyName)")
       // }
        do {
            
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            //print("result\(jsonResult)")
            let requestsDict = jsonResult.objectForKey("requests") as! [NSDictionary]
            dataManager.requestsArray.removeAll()
            
            for request in requestsDict {
                
                
                let requestSuppliesArray = request.objectForKey("supplies") as! [NSDictionary]
               // print("SA:\(requestSuppliesArray):SA")
                
                for supply in requestSuppliesArray {
                    let requestEntityDescription :NSEntityDescription! = NSEntityDescription.entityForName("RequestsData", inManagedObjectContext: managedObjetContext)
                    let currentRequest:RequestsData! = RequestsData(entity: requestEntityDescription, insertIntoManagedObjectContext: managedObjetContext)
                    
                    let dateString = request.objectForKey("created_at") as! String
                    currentRequest.createdDate = getDateFromString(dateString)

                    let supplyId = String(supply["id"] as! Int)
                    print("id \(supplyId)")
                    currentRequest.requestSupplyID = supplyId
                    let foundSupply = findSupplyWithID(supplyId)
                   // if currentRequest.requestSupplyName != foundSupply.supplyName{
                       // print("no supply")
                    //}else {
                    //print("\(supplyId)")
                    currentRequest.requestSupplyName = foundSupply?.supplyName
                    
                    
                    if let response = supply.objectForKey("response") as? NSDictionary {
                        let supplyEntityDescription :NSEntityDescription! = NSEntityDescription.entityForName("ResponseData", inManagedObjectContext: managedObjetContext)
                        
                        let currentResponse:ResponseData! = ResponseData(entity: supplyEntityDescription, insertIntoManagedObjectContext: managedObjetContext)
                        
                      
                        
                        currentResponse.responseID = String(response["id"] as! Int!)
                        currentResponse.responseType = response["type"] as? String
                        currentResponse.toRequestsData = currentRequest
                        
                        let responseDateString = response["created_at"] as! String
                        currentResponse.respondedAt = getDateFromString(responseDateString)
                        
                        print("RI \(currentResponse.responseID) RT \(currentResponse.responseType)RD\(currentResponse.respondedAt)")
                        
                        
                        
                                           } else {
                        print("No Response")
                        
                        
                    
                    
                    }
                
                   // }
            }
                    

                
            }
            
            appDelegate.saveContext()
           
            dataManager.requestsArray = dataManager.fetchRequests()!
            dataManager.responseArray = dataManager.fetchResponses()!
            
            dispatch_async(dispatch_get_main_queue()){
                
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedDataFromServer", object: nil))
            }
        } catch {
            print("JSON Parsing Error")
        }
        
    }
    
    //MARK: - DATE FORMATER
    
    func getDateFromString(dateString: String) -> NSDate? {
        
        let dateFormatter = NSDateFormatter()
        // 2015-09-13 14:00:26 -0400
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZZZZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(dateString)
       // print("stringDate:\(dateString) actualDate:\(date)")
        return date
        
    }
    
    func formatStringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MMMM-dd"
        return dateFormatter.stringFromDate(date)
    }
    
    //MARK: - PULL TO REFRESH METHOD
    func pullToRefresh(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
                self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
                //self.requestsList.addSubview(refreshControl)
                //self.refreshTableView()

    }
    
    
    
    
    
    
    
}
