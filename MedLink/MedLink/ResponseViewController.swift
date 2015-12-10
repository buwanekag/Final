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
    var baseUrlString = "medlink-staging.herokuapp.com"
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
        
        cell.textLabel!.font = UIFont(name: "Helvetica", size: 12)
        let request = dataManager.requestsArray[indexPath.row]
        print("Cell:\(request.requestSupplyName!)XXX")
        cell.textLabel!.text = request.requestSupplyName!
       // cell.responseSupplyDisplay.text! = request.requestSupplyName!
        
        
        return cell
        
    }
    
    func displaySelections() {
        var selections = ""
        var index = 0
        for supplySelected in selectedRequestsArray {
            if supplySelected {
                selections = selections + dataManager.requestsArray[index].requestSupplyName! + "\n"
              //  print("Sel:\(selections)")
            }
            index++
        }
        //print("Array:\(selectedRequestsArray)")
        requestsDisplay.text! = selections
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let row = indexPath.row
       // print("Select \(row)")
        
        //  selectedItems.append(dataManager.suppliesArray[indexPath.row])
        
        selectedRequestsArray[row] = !selectedRequestsArray[row]
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        displaySelections()
        
    }
    
    
    
    
    
    
    //MARK: - INTERACTIVE METHOD
    
    @IBAction func receivedButtonPressed(sender:UIButton){
        
        
        var supplyIds = [String]()
        var index = 0
        for supplySelected in selectedRequestsArray {
            if supplySelected {
                supplyIds.append(dataManager.requestsArray[index].requestSupplyID!+"\n")
                
            }
            index++
        }
        
        
        sendReceivedRequestToServer(requestsDisplay.text!, supplyIds: supplyIds)
    }
    
    @IBAction func flagButtonPressed(sender:UIButton){
        
        
        var supplyIds = [String]()
        var index = 0
        for supplySelected in selectedRequestsArray {
            if supplySelected {
                supplyIds.append(dataManager.requestsArray[index].requestSupplyID!+"\n")
                
            }
            index++
        }
        
        
        sendFlagRequestToServer(requestsDisplay.text!, supplyIds: supplyIds)
    }

    
    //MARK: - SEND RECEIVED RESPONSE METHOD
    
    func sendReceivedRequestToServer(message:String,supplyIds:[String]) {
        let url = NSURL(string: "https://\(baseUrlString)/api/v1/responses")
        let request = NSMutableURLRequest(URL: url!,cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        var ids = ""
        let newItems = supplyIds.map({ item in "{{ response_id_here }}/mark_received=\(item)"})
        ids = newItems.joinWithSeparator("&")
        request.HTTPMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "message=\(message)& \(ids)".dataUsingEncoding(NSUTF8StringEncoding)
        request.signWithAccessIdentifier("2376", andSecret: "HLHSDDp+95IqeCuAjCslZRqRcPdnRXFd55W904lamDMQh9pa+UIrNRz+hiPpg5u7FKKPF5GjQPEPSWYbzbGbpw==")
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    let alert = UIAlertController (title: "Not Submited", message: "Your request was not sent", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Resend", style: .Default, handler: nil ))
                    self.presentViewController(alert, animated: true, completion: nil)
                    print("error=\(error)")
                }
                return
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    let alert = UIAlertController (title: "Submited", message: "Your request was sent", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil ))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                print("No Data")
            }
        }
        task.resume()
    }

    //MARK: - SEND FLAG RESPONSE METHOD
    
    func sendFlagRequestToServer(message:String,supplyIds:[String]) {
        let url = NSURL(string: "https://\(baseUrlString)/api/v1/responses")
        let request = NSMutableURLRequest(URL: url!,cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        var ids = ""
        let newItems = supplyIds.map({ item in "{{ response_id_here }}/flag=\(item)"})
        ids = newItems.joinWithSeparator("&")
        request.HTTPMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "message=\(message)& \(ids)".dataUsingEncoding(NSUTF8StringEncoding)
        request.signWithAccessIdentifier("2376", andSecret: "HLHSDDp+95IqeCuAjCslZRqRcPdnRXFd55W904lamDMQh9pa+UIrNRz+hiPpg5u7FKKPF5GjQPEPSWYbzbGbpw==")
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    let alert = UIAlertController (title: "Not Submited", message: "Your request was not sent", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Resend", style: .Default, handler: nil ))
                    self.presentViewController(alert, animated: true, completion: nil)
                    print("error=\(error)")
                }
                
                return
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    let alert = UIAlertController (title: "Submited", message: "Your request was sent", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil ))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                print("No Data")
            }
        }
        task.resume()
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
