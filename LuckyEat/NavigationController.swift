//
//  NavigationController.swift
//  LuckyEat
//
//  Created by Mobile on 12/6/17.
//  Copyright © 2017 Mobile. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    var eatType : String = ""
    var eatTyperList : NSArray =  [""]
    let userDefaults = UserDefaults.standard
    var datastore = Array<String>()
    var history = Array<String>()
    var result : String = ""
    var resetChance : Int = 0
    var timeperiod : String!
    var confirmed : Bool!
    var dict : Dictionary< String , AnyObject>? = [:]
    var dictCopy : Dictionary <String , String>? = [:]
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

    override func viewDidLoad() {
        super.viewDidLoad()
        if(userDefaults.array(forKey: "history") != nil){
            history = userDefaults.array(forKey: "history") as! Array<String>
        }
        
        let fileManager = FileManager.default
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/resturant.plist")
        if(fileManager.fileExists(atPath: path)){
            print("\(fileManager.fileExists(atPath: path)) , \(path)" )
            if let plistpath = NSHomeDirectory()+"/Documents/resturant.plist" as? String {
            //If your plist contain root as Array
            let dictionary = NSDictionary(contentsOfFile: plistpath)
                
            ////If your plist contain root as Dictionary
//            if let dic = NSDictionary(contentsOfFile: plistpath) as? [String: AnyObject] {
                for (key,value) in dictionary!{
                    let data = value as! Dictionary<String , String>
                    dictCopy![data["name"] as! String] = data["style"] as! String
                }
                print(dictCopy as Any)
//            }
            }else{
                let path = NSHomeDirectory() + "/Documents/resturant.plist"
                print(path + "Not Found!")
            }
        }
        
//        let date = Date()
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: date)
//        let month = calendar.component(.month, from: date)
//        let day = calendar.component(.day, from: date)
        
        
        
        //handle period
//        if(userDefaults.object(forKey: "timestamp") == nil){
//            resetChance = 3
//            confirmed = false
////            chance.text = "chance : \(resetChance)"
//            userDefaults.set(resetChance, forKey: "chance")
//            userDefaults.set("\(String(year))\(String(month))\(String(day)))", forKey: "timestamp")
//            userDefaults.set(confirmed, forKey: "confirmed")
//            print("restCahcne = \(resetChance)")
//            userDefaults.synchronize()
//        }else{
//            if((userDefaults.string(forKey: "timestamp") == "\(String(year))\(String(month))\(String(day))")){
////                chance.text = "chance : \(userDefaults.integer(forKey: "chance"))"
//                resetChance = userDefaults.integer(forKey: "chance")
//                confirmed = userDefaults.bool(forKey: "confirmed")
//            }else{
//                resetChance = 3
//                confirmed = false
////                chance.text = "chance : \(resetChance)"
//                userDefaults.set(resetChance, forKey: "chance")
//                userDefaults.set("\(String(year))\(String(month))\(String(day))", forKey: "timestamp")
//                userDefaults.set(confirmed, forKey: "confirmed")
//                for i in 0...eatTyperList.count-1{
//                    userDefaults.removeObject(forKey: "\(eatTyperList[i])"+"Value")
//                }
//                userDefaults.removeObject(forKey: "tempValue")
//                userDefaults.removeObject(forKey: "tempResult")
//                userDefaults.synchronize()
//            }
//        }
        
        
        
        
        
        
        
//        if(userDefaults.string(forKey: "\(eatType)"+"Value") != nil){
//            var count : Int = 0
//            var convertcount : String = String("\(count)")
//            for (key,value) in self.dict! {
//                let words: String = value["name"] as! String
//                if(words == userDefaults.string(forKey: "\(eatType)"+"Value")){
//                    result = userDefaults.string(forKey: "\(eatType)"+"Value")!
//                }
//            }
//
////            if(eatType == dict[dict.index(forKey: userDefaults.string(forKey: "\(eatType)"+"Value")!)!].value){
////                result = userDefaults.string(forKey: "\(eatType)"+"Value")!
////            }else{
////                random(navigation: navigation)
////            }
//
//        }else if(userDefaults.string(forKey: "tempResult") != nil){
//            result = userDefaults.string(forKey: "tempResult")!
//        }
//        else{
//            random(navigation: navigation)
//        }
        
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
