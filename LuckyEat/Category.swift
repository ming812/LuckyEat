//
//  Category.swift
//  LuckyEat
//
//  Created by Mobile on 12/5/17.
//  Copyright © 2017 Mobile. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView

class Category: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var tableview: UITableView!
    var ListArray : NSArray = ["Rice","Noodle","Fastfood","Hong Kong-style Diner"]
    
    let fileManager = FileManager.default
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    var path : String!
    var dict : Dictionary<String, AnyObject>! = [:]
    var activityIndicatorView : NVActivityIndicatorView?
    var roundedBackgroundView : UIView!
    var isolateView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        path = documentDirectory.appending("/resturant.plist")
        
//        tableview.backgroundView = UIImageView(image : UIImage(named : "luckyEat_bg5"))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(!getPlist()){
            showProgressDialog()
            handleRequest()
        }
        addNavBarImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell") as! CategoryCell
       
        let imagename : String = ListArray[indexPath.row] as! String
        cell.categoryImage.image = UIImage(named : imagename.lowercased())
        cell.categoryImage.sizeToFit()
        
        cell.categoryTitle.text = "\(ListArray[indexPath.row])"
        cell.categoryTitle.sizeToFit()
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navigationController = self.navigationController {
            let navigation : NavigationController = navigationController as! NavigationController
                navigation.eatType = "\(ListArray[indexPath.row])"
                navigation.eatTyperList = ListArray
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main" , bundle : nil)
            let resultPage = storyboard.instantiateViewController(withIdentifier: "LuckyDrawResult") as! LuckyDrawResult
            
            navigation.pushViewController(resultPage, animated: true)
        }
    }
    
    func addNavBarImage(){
            let image = #imageLiteral(resourceName: "refresh")
            
        let button = UIButton.init(type: .custom)
        button.setImage(image, for: UIControlState.normal)
        button.addTarget(self, action:#selector(Category.showProgressDialog), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    @objc func handleRequest(){
//        DispatchQueue.main.async {
//
//            self.activityIndicatorView?.isHidden=false
//            self.activityIndicatorView?.startAnimating()
//        }
        //let scriptURL = "http://validate.jsontest.com/"
        let scriptURL = "https://n9swk68i7d.execute-api.ap-northeast-1.amazonaws.com/LuckyDraw/luckydraw/getlist"
        //let URLwithparams = scriptURL + "?json=%7B%22key%22:%22value%22%7D"
        let myURL = NSURL(string : scriptURL)
        var request = URLRequest(url: myURL! as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            data,response,error in
            // Check for error
            if error != nil
            {
                DispatchQueue.main.async {
                self.activityIndicatorView?.stopAnimating()
                    self.isolateView.isHidden = true
                    self.roundedBackgroundView.isHidden = true
                }
                if(!self.getPlist()){
                    let alertDialog = UIAlertController(title: " Get resturant list failed ! ",
                                                        message : "Connection failed, please check your network connection or turn on your wi-fi",
                                                        preferredStyle : UIAlertControllerStyle.alert)
                    let alertAction = UIAlertAction(title : "Retry",
                                                    style : UIAlertActionStyle.default,
                                                    handler :{(alert:UIAlertAction!) in self.handleRequest()})
                    alertDialog.addAction(alertAction)
                    self.present(alertDialog, animated: true, completion: nil)
                }else{
                    let alertDialog = UIAlertController(title: " Get resturant list failed ! ",
                                                        message : "Get resutrant data failed, please try again",
                                                        preferredStyle : UIAlertControllerStyle.alert)
                    let alertAction = UIAlertAction(title : "OK",
                                                    style : UIAlertActionStyle.default,
                                                    handler :nil)
                    alertDialog.addAction(alertAction)
                    self.present(alertDialog, animated: true, completion: nil)
                }
                print("error=\(error)")
                return
            }
            
            // Print out response string
            //            if let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
            //                print("responseString = \(responseString)")
            //            }
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoArr = try JSONSerialization.jsonObject(with: data!, options:[]) as? Array<Dictionary<String, String>> {
                    
                    // Print out dictionary
                    print(convertedJsonIntoArr)
                    
//                    if let lastRecord = convertedJsonIntoArr.last {
//                        DispatchQueue.main.async {
//                            self.showmessage.text = lastRecord["name"]
//                        }
//                    }
                    var count :Int = 0
                    for dict in convertedJsonIntoArr {
                        self.dict!["\(count)"] = convertedJsonIntoArr[count] as AnyObject
                        count += 1
                    }
                    print("dictionary result = \(self.dict as Any)")
                    // Get value by key
                    //                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    //                    print(firstNameValue!)
                    
                    if(!self.getPlist()){
                        let success = (self.dict as NSDictionary).write(toFile: self.path, atomically: true)
                            print(success)
                        DispatchQueue.main.async {
                        self.activityIndicatorView?.stopAnimating()
                            self.isolateView.isHidden = true
                            self.roundedBackgroundView.isHidden = true
                        }
                    }else{
                        do{
                        try self.fileManager.removeItem(atPath: self.path)
                            let success = (self.dict as NSDictionary).write(toFile: self.path, atomically: true)
                            print(success)
                            DispatchQueue.main.async {
                            self.activityIndicatorView?.stopAnimating()
                                self.isolateView.isHidden = true
                                self.roundedBackgroundView.isHidden = true
                            }
                        }catch let error as NSError{
                            print(error.localizedDescription)
                            DispatchQueue.main.async {
                            self.activityIndicatorView?.stopAnimating()
                                self.isolateView.isHidden = true
                                self.roundedBackgroundView.isHidden = true
                            }
                        }
                    }
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                self.activityIndicatorView?.stopAnimating()
                    self.isolateView.isHidden = true
                    self.roundedBackgroundView.isHidden = true
                }
            }
            
        }
        
        task.resume()
        
        
    }
    
    func getPlist() -> Bool{
        if(!self.fileManager.fileExists(atPath: self.path)){
            return false
        }else{
            return true
        }
    }
    
   @objc func showProgressDialog(){
        let screenWidth = UIScreen.main.bounds.width/2 - 50
        let screenHeight = UIScreen.main.bounds.height/2 - 50
    
        self.isolateView = UIView(frame: CGRect(x: 0 , y: 0 ,width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height))
        self.isolateView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.isolateView.isHidden = true
        //create a rounded rectangle
        let backgroundView = CGRect(x: screenWidth - 25, y: screenHeight - 25 ,width: 150 , height: 150)
        self.roundedBackgroundView = UIView.init(frame: backgroundView)
        roundedBackgroundView.layer.cornerRadius = 10
        roundedBackgroundView.backgroundColor = UIColor.gray
        self.roundedBackgroundView.isHidden = true
        self.view.addSubview(self.isolateView)
        self.view.addSubview(self.roundedBackgroundView!)
        //end of creation
        
        self.activityIndicatorView =  NVActivityIndicatorView(frame: CGRect(x: screenWidth, y: screenHeight, width: 100, height: 100), type: NVActivityIndicatorType.ballPulseSync)
        
        if let activityIndicatorView = self.activityIndicatorView {
            activityIndicatorView.color = UIColor.blue
            self.view.addSubview(activityIndicatorView)
            self.isolateView.isHidden = false
            self.roundedBackgroundView.isHidden = false
            activityIndicatorView.startAnimating()
        }
        if(self.getPlist()){
            handleRequest()
        }
    }



}
