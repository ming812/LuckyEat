//
//  LuckyDrawResult.swift
//  LuckyEat
//
//  Created by Mobile on 12/7/17.
//  Copyright © 2017 Mobile. All rights reserved.
//

import UIKit

class LuckyDrawResult: UIViewController {
    
    @IBOutlet weak var showmessage: UILabel!
    
    @IBOutlet weak var chance: UILabel!
    
    @IBOutlet weak var reset: UIButton!
    
    @IBOutlet weak var confirm: UIButton!
    
    var navigation : NavigationController!
    
    let userDefaults = UserDefaults.standard
    
    var dict: [String: String] = [:]
    
    var datastore = Array<String>()
    var history = Array<String>()
    var result : String = ""
    var second = 5
    var timer = Timer()
    var isTimerRunning = false
    var resetChance : Int!
    var timeperiod : String!
    var confirmed : Bool!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
         Drawing code
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
//        if(userDefaults.array(forKey: "history") != nil){
//            history = userDefaults.array(forKey: "history") as! Array<String>
//        }
        
        reset.addTarget(self, action: #selector(LuckyDrawResult.handleRestButton), for: UIControlEvents.touchDown)
        
        confirm.addTarget(self, action: #selector(LuckyDrawResult.handleConfirmButton), for: UIControlEvents.touchDown)
        
//        let date = Date()
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: date)
//        let month = calendar.component(.month, from: date)
//        let day = calendar.component(.day, from: date)
        
        
        if let navigationController = self.navigationController {
            navigation = navigationController as! NavigationController
            self.resetChance = navigation.resetChance
            self.timeperiod = navigation.timeperiod
            self.confirmed = navigation.confirmed
            self.dict = navigation.dictCopy!
            
//        //handle period
//        if(userDefaults.object(forKey: "timestamp") == nil){
//            resetChance = 3
//            confirmed = false
            chance.text = "chance : \(String(resetChance))"
//            userDefaults.set(resetChance, forKey: "chance")
//            userDefaults.set("\(String(year))\(String(month))\(String(day)))", forKey: "timestamp")
//            userDefaults.set(confirmed, forKey: "confirmed")
//            print("restCahcne = \(resetChance)")
//            userDefaults.synchronize()
//        }else{
//            if((userDefaults.string(forKey: "timestamp") == "\(String(year))\(String(month))\(String(day))")){
//                chance.text = "chance : \(userDefaults.integer(forKey: "chance"))"
//                resetChance = userDefaults.integer(forKey: "chance")
//                confirmed = userDefaults.bool(forKey: "confirmed")
//            }else{
//                resetChance = 3
//                confirmed = false
//                chance.text = "chance : \(resetChance)"
//                userDefaults.set(resetChance, forKey: "chance")
//                userDefaults.set("\(String(year))\(String(month))\(String(day))", forKey: "timestamp")
//                userDefaults.set(confirmed, forKey: "confirmed")
//                for i in 0...navigation.eatTyperList.count-1{
//                    userDefaults.removeObject(forKey: "\(navigation.eatTyperList[i])"+"Value")
//                }
//                userDefaults.removeObject(forKey: "tempValue")
//                userDefaults.removeObject(forKey: "tempResult")
//                userDefaults.synchronize()
//            }
//        }
        
            
//            print("eatType: \(navigation.eatType)")
            if(userDefaults.string(forKey: "\(navigation.eatType)"+"Value") != nil){
                var bingo = false
                for(key,value) in self.dict{
                    let words: String = key as String
                    if(words == userDefaults.string(forKey: "\(navigation.eatType)"+"Value")){
                        bingo = true
                    }
                }
                if(bingo){
                   result = userDefaults.string(forKey: "\(navigation.eatType)"+"Value")!
                }
                else{
                    random(navigation: navigation)
                }

            }else if(userDefaults.string(forKey: "tempResult") != nil){
                result = userDefaults.string(forKey: "tempResult")!
            }else{
            random(navigation: navigation)
            }
            
        }
        
        if(userDefaults.bool(forKey: "confirmed") != nil && userDefaults.bool(forKey: "confirmed") == true){
            confirm.backgroundColor = UIColor.gray
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        showmessage.text = result
        showmessage.text = "\(second)"
        runTimer()
        
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(LuckyDrawResult.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        isTimerRunning = true
        if(second>0){
            second -= 1
            showmessage.text = "\(second)"
        }else{
            showmessage.text = result
            reset.isHidden = false
            confirm.isHidden = false
            chance.isHidden = false
            timer.invalidate()
            isTimerRunning = false
        }
        
    }
    
    @objc func handleRestButton(){
        if(userDefaults.integer(forKey: "chance")>0){
            random(navigation: navigation)
            resetChance? -= 1
            chance.text = "chance : \(String(resetChance))"
            showmessage.text = result
            userDefaults.set(resetChance, forKey: "chance")
        }
        userDefaults.synchronize()
    }
    
     func random(navigation : NavigationController){
        for i in 0 ..< dict.count {
            let key: String = Array(dict.keys)[i]
            let value: String = Array(dict.values)[i]
            print("\(value.lowercased())   ,   \(navigation.eatType.lowercased())")
            if(value.lowercased() == navigation.eatType.lowercased() ){
                if(history.count > 0){
                    if(history.contains("\(key)")){
                        
                    }else{
                        datastore += [key]
                    }
                }else{
                    datastore += [key]
                }
            }
            
        }
        print(datastore)
        
        if(datastore.count>0){
            
            let randomNumber : Int = Int(arc4random_uniform(UInt32(Int(datastore.count))))
            let randomNumberUse = (Int)(randomNumber)
            result = datastore[randomNumberUse]
            navigation.result = self.result
            userDefaults.set(result, forKey: "\(navigation.eatType)"+"Value")
            userDefaults.synchronize()
        }else{
            result = "No data"
        }
    }
    
    @objc func handleConfirmButton() {
        if(!confirmed){
        history.append("\(result)")
        userDefaults.set(history, forKey: "history")
        userDefaults.set(result, forKey: "tempResult")
        userDefaults.removeObject(forKey: "\(navigation.eatType)"+"Value")
        userDefaults.synchronize()
        let alertController = UIAlertController(title : "Lucky Draw Result",
                                                message : "Your random resturarnt result confirmed, Please press 'back' button at top left corner!",
                                                preferredStyle : UIAlertControllerStyle.alert)
        
        let alertAction = UIAlertAction(title : "OK",
                                        style : UIAlertActionStyle.default,
                                        handler : nil )
        
        alertController.addAction(alertAction)
        
        self.present(alertController,
                                   animated : true,
                                   completion : nil)
        confirmed = true
        userDefaults.set(confirmed, forKey: "confirmed")
        confirm.backgroundColor = UIColor.gray
        }else{
            confirm.isEnabled = false
        }
        }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
    
    



