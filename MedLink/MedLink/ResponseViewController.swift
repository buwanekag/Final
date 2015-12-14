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
    @IBOutlet var flagButton: UIButton!
    @IBOutlet var receivedButton: UIButton!
    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var receivedImageView: UIImageView!
    
    
    
    //MARK: - TABLE VIEW METHOD 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.requestsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
       
       
        if selectedRequestsArray[indexPath.row] {
            flagButton.hidden = false
            receivedButton.hidden = false
            flagImageView.hidden = false
            receivedImageView.hidden = false
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
            flagButton.hidden = true
            receivedButton.hidden = true
            flagImageView.hidden = true
            receivedImageView.hidden = true
            
        }
        
        
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
                print("Sel:\(selections)")
            }
            index++
        }
        //print("Array:\(selectedRequestsArray)")
        requestsDisplay.text! = selections
        requestsDisplay.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        requestsDisplay.textColor = UIColor.blueColor()

        
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
                supplyIds.append(dataManager.requestsArray[index].requestSupplyID!)
            }
            index++
        }
        sendReceivedRequestToServer(supplyIds)
    }
    
    @IBAction func flagButtonPressed(sender:UIButton){
        
        
        var supplyIds = [String]()
        var index = 0
        for supplySelected in selectedRequestsArray {
            if supplySelected {
                supplyIds.append(dataManager.requestsArray[index].requestSupplyID!)
                
            }
            index++
        }
        
        
        sendFlagRequestToServer(supplyIds)
     
        requestsDisplay.text! = ""
       
    }

    
    //MARK: - SEND RECEIVED RESPONSE METHOD
    
    func sendReceivedRequestToServer(supplyIds:[String]) {
        for supplyID in supplyIds {
            let urlString = "https://\(baseUrlString)/api/v1/responses/\(supplyID)/mark_received"
            print("URL: \(urlString)")
            let url = NSURL(string: urlString)
            let request = NSMutableURLRequest(URL: url!,cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
            request.HTTPMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.signWithAccessIdentifier("2376", andSecret: "HLHSDDp+95IqeCuAjCslZRqRcPdnRXFd55W904lamDMQh9pa+UIrNRz+hiPpg5u7FKKPF5GjQPEPSWYbzbGbpw==")
            let urlSession = NSURLSession.sharedSession()
            let task = urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()){
                        let alert = UIAlertController (title: "Submited", message: "Your request was sent", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil ))
                        self.presentViewController(alert, animated: true, completion: nil)
                        print("error=\(response)")
                    }
                    return
                } else {
                    dispatch_async(dispatch_get_main_queue()){
                        let alert = UIAlertController (title: "Not Submited", message: "Your request was not sent", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Resend", style: .Default, handler: nil ))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    print("response=\(response)")
                }
            }
            task.resume()
            
        }
    }
    
    //MARK: - SEND FLAG RESPONSE METHOD
    
    func sendFlagRequestToServer(supplyIds:[String]) {
        for supplyID in supplyIds {
            let urlString = "https://\(baseUrlString)/api/v1/responses/\(supplyID)/mark_received"
            print("URL: \(urlString)")
            let url = NSURL(string: urlString)
            let request = NSMutableURLRequest(URL: url!,cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
            request.HTTPMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.signWithAccessIdentifier("2376", andSecret: "HLHSDDp+95IqeCuAjCslZRqRcPdnRXFd55W904lamDMQh9pa+UIrNRz+hiPpg5u7FKKPF5GjQPEPSWYbzbGbpw==")
            let urlSession = NSURLSession.sharedSession()
            let task = urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()){
                        let alert = UIAlertController (title: "Submited", message: "Your request was sent", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil ))
                        self.presentViewController(alert, animated: true, completion: nil)
                        print("error=\(response)")
                    }
                    return
                } else {
                    dispatch_async(dispatch_get_main_queue()){
                        let alert = UIAlertController (title: "Not Submited", message: "Your request was not sent", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Resend", style: .Default, handler: nil ))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    print("response=\(response)")
                }
            }
            task.resume()
            
        }
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
            //flagButton.setBackgroundImage(UIImage(named: "flag"));, forState: .Normal)
            //let flag = UIImage(named: "flag")
            //let received = UIImage(named: "received")
            //flagButton.setImage(flag, forState: .Normal)
          //  flagButton.imageView.se
           // receivedButton.setImage(received, forState: .Normal)
            flagImageView.image = UIImage(named: "flag")
            receivedImageView.image = UIImage(named: "received")
            
            
            
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
