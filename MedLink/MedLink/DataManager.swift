//
//  DataManager.swift
//  MedLink
//
//  Created by Buwaneka Galpoththawela on 11/13/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//


import UIKit
import CoreData

class DataManager: NSObject{
    
    
    static let sharedInstance = DataManager()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjetContext : NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var suppliesArray = [SuppliesData]()
    var requestsArray = [RequestsData]()
    var responseArray = [ResponseData]()
    
    
    
    func getNameString(responseSupplyID:String){
        
        for responseSupplyID in responseArray{
            
            for supplyID in suppliesArray {
                
                if supplyID == responseSupplyID {
                    
                    print("got it")
                }
                
                
            }
        }
        
        
    }
    
    
    
    
    
    //MARK: -  SUPPLIES FETCH METHOD
    
    
    func fetchSupplies() -> [SuppliesData]? {
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "SuppliesData")
        fetchRequest.sortDescriptors = [NSSortDescriptor (key: "supplyName", ascending: true)]
        do{
            let tempArray = try managedObjetContext!.executeFetchRequest(fetchRequest)
                as! [SuppliesData]
            // print("list:\(tempArray)")
            
            //print("list:\(suppliesArray)")
            return tempArray
            
            
        }catch {
            return nil
        }
    }
    
    
    //MARK: -  REQUESTS FETCH METHOD
    
    
    func fetchRequests() -> [RequestsData]? {
        
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "RequestsData")
        fetchRequest.sortDescriptors = [NSSortDescriptor (key: "createdDate", ascending: true)]
        do{
            let tempArray = try managedObjetContext!.executeFetchRequest(fetchRequest)
                as! [RequestsData]
            
            //print("list:\(tempArray)")
            
            return tempArray
            
            
        }catch {
            return nil
        }
        
    }
    
    //MARK: - REQUEST SUPPLY FETCH METHOD
    
    
    func fetchResponses() -> [ResponseData]? {
        
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "ResponseData")
        fetchRequest.sortDescriptors = [NSSortDescriptor (key: "responseID", ascending: true)]
        do{
            let tempArray = try managedObjetContext!.executeFetchRequest(fetchRequest)
                as! [ResponseData]
            
            // print("list:\(tempArray)")
            
            return tempArray
            
            
        }catch {
            return nil
        }
      
        
    }
    
    
    func fetchCoreData(){
        requestsArray = fetchRequests()!
        responseArray = fetchResponses()!
        dispatch_async(dispatch_get_main_queue()){
            
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "gotCoreData", object: nil))
        }

        
    }
    
    override init() {
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchCoreData", name: "noDataFromServer", object: nil)
       

        
        
    }
    
    

    
    
    
    
    
    
    
    
    
    

    
    
    
    

}
