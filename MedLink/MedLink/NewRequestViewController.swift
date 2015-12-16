//
//  NewRequestViewController.swift
//  MedLink
//
//  Created by Buwaneka Galpoththawela on 11/30/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit

class NewRequestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate{
    
    var cloudManager = CloudManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    let messageComposer = MessageComposer()
    var selectedSupplyArray = [Bool]()
    var selectedItems = [String:SuppliesData]()
    var baseUrlString = "medlink-staging.herokuapp.com"
    
    @IBOutlet var supplyList: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var selectedSupplyDisplay :UITextView!
    @IBOutlet var logoDisplay :UIImageView!
    @IBOutlet var textMessageButton:UIButton!
    @IBOutlet var submitButton:UIButton!
    @IBOutlet var messageTextView: UITextView!
    
    
   
   
    

    
    //MARK: - TABLEVIEW METHOD
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.suppliesArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        return populateCell(tableView, indexPath: indexPath)
        
    }
    
    func populateCell(tableView: UITableView, indexPath:NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if selectedSupplyArray[indexPath.row] {
            
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
            
        }
        let displayUser = dataManager.suppliesArray[indexPath.row]
        cell.textLabel?.text = displayUser.supplyName
        
        return cell
        
        
    }
    
    
    
    func displaySelections() {
        var selections = ""
        var index = 0
        for supplySelected in selectedSupplyArray {
            if supplySelected {
                selections = selections + dataManager.suppliesArray[index].supplyName!+"-"+dataManager.suppliesArray[index].supplyShortCode!+"\n"
            }
            index++
        }
        
        selectedSupplyDisplay.text! = selections
        selectedSupplyDisplay.textColor = UIColor.blackColor()
        selectedSupplyDisplay.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        
        
        if selectedSupplyDisplay.text.characters.count > 0{
            submitButton.hidden = false
            textMessageButton.hidden = false
        }else {
            submitButton.hidden = true
            textMessageButton.hidden = true
        }
        //selectedSupplyDisplay.layer.borderColor = CGColorCreateCopy()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let row = indexPath.row
        print("Select \(row)")
        
        //  selectedItems.append(dataManager.suppliesArray[indexPath.row])
        
        selectedSupplyArray[row] = !selectedSupplyArray[row]
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        displaySelections()
        
    }
    
    
    
    
    //MARK: - INTERACTIVE METHOD
    
    @IBAction func submitButtonPressed(sender:UIButton){
        var supplyIds = [String]()
        var index = 0
        for supplySelected in selectedSupplyArray {
            if supplySelected {
                supplyIds.append(dataManager.suppliesArray[index].supplyID!)
                
                print("suppies\(supplyIds)")
            }
            index++
        }
        sendRequestToServer(messageTextView.text!, supplyIds: supplyIds)
        messageTextView.text! = ""
        supplyIds.removeAll()
        selectedSupplyDisplay.text! = ""
    }
    
  
    //MARK: - SEND REQUEST METHOD
    
    func sendRequestToServer(message:String,supplyIds:[String]) {
        
        let url = NSURL(string: "https://\(baseUrlString)/api/v1/requests")
        
        let request = NSMutableURLRequest(URL: url!,cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        
        var ids = ""
        let newItems = supplyIds.map({ item in "supply_ids[]=\(item)"})
        ids = newItems.joinWithSeparator("&")
        
        
        request.HTTPMethod = "POST"
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "message=\(message)& \(ids)".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        
        request.signWithAccessIdentifier("2376", andSecret: "HLHSDDp+95IqeCuAjCslZRqRcPdnRXFd55W904lamDMQh9pa+UIrNRz+hiPpg5u7FKKPF5GjQPEPSWYbzbGbpw==")
        
        let urlSession = NSURLSession.sharedSession()
        
        let task = urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    let alert = UIAlertController (title: "Not Submited", message: "Request  not sent send text message", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil ))
                    //alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: sen))
                    
                    
                     self.presentViewController(alert, animated: true, completion: nil)
                    
                    print("error=\(error)")
                }
                
                return
                
                
                //                print("Data\(data)")
                
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    let alert = UIAlertController (title: "Submited", message: "Your request was sent", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil ))
                    //self.actionForLayer(CALayer, forKey: "")
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
                print("No Data")
            }
        }
        task.resume()
        
        
        
    }
    

    
    
    //MARK: - MESSAGE METHOD
    
    @IBAction func sendTextMessageButtonTapped(sender: UIButton) {
        if (messageComposer.canSendText()) {
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            
            presentViewController(messageComposeVC, animated: true, completion: nil)
        } else {
            
            let errorAlert = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages", preferredStyle: .ActionSheet)
            errorAlert
        }
    }
    
    
    //MARK: - NOTIFICATION CENTER
    
    func newDataReceived() {
        supplyList.reloadData()
        
    }
    
    
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDataReceived", name: "receivedSupplyDataFromServer", object: nil)
        //messageTextField.delegate = self
       messageTextView.delegate = self
        
         logoDisplay.image = UIImage(named: "pcLogo")
        view.backgroundColor = UIColor.whiteColor()
     
        textMessageButton.hidden = true
        submitButton.hidden = true
        
        
    
    
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedSupplyArray.removeAll()
        for _ in dataManager.suppliesArray {
            selectedSupplyArray.append(false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
