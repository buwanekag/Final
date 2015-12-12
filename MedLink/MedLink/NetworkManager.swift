//
//  NetworkManager.swift
//  MedLink
//
//  Created by Buwaneka Galpoththawela on 11/13/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    static let sharedInstance = NetworkManager()
    
    
    var serverReach: Reachability?
    var serverAvailable = false
    
    func reachabilityChanged(note: NSNotification) {
        let reach = note.object as! Reachability
        serverAvailable = !(reach.currentReachabilityStatus().rawValue == NotReachable.rawValue)
        if serverAvailable {
            print("changed: server available")
        }else {
            dispatch_async(dispatch_get_main_queue()){
                
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "noDataFromServer", object: nil))
            }
            
            
            
            
            
            
            
            print("changed: server not available")
        }
    }
    
    
    override init() {
        super.init()
        print("Starting Network Manager")
       let cloudManager = CloudManager.sharedInstance
        serverReach = Reachability(hostName: cloudManager.baseUrlString)
        serverReach?.startNotifier()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: kReachabilityChangedNotification, object: nil)
    }

    
    
    
    

}
