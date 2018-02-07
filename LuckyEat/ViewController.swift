//
//  ViewController.swift
//  LuckyEat
//
//  Created by Mobile on 11/30/17.
//  Copyright © 2017 Mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var hamburger: UIImageView!
    @IBOutlet weak var noodle: UIImageView!
    @IBOutlet weak var rice: UIImageView!
    @IBOutlet weak var homebtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        homebtn.addTarget(self, action: #selector(ViewController.btnAction), for : UIControlEvents.touchDown )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        UIView.animate(withDuration: 5.0) {
        //            var frame = self.imageView.frame
        //            frame.origin.y = 300
        //            self.imageView.frame = frame
        //        };
        
        UIView.animateKeyframes(withDuration: 5.0, delay: 1.0, options: [UIViewKeyframeAnimationOptions.autoreverse, UIViewKeyframeAnimationOptions.repeat], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 5.0, animations: {
                var frame = self.hamburger.frame
                frame.origin.x = self.view.frame.width - frame.width
                self.hamburger.frame = frame
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 10.0, animations: {
                var frame = self.noodle.frame
                frame.origin.x = self.view.frame.width - frame.width
                self.noodle.frame = frame
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 15.0, animations: {
                var frame = self.rice.frame
                frame.origin.x = self.view.frame.width - frame.width
                self.rice.frame = frame
            })
            
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func btnAction(sender : UIButton){
        let storyboard : UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        
        let resultPage = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
        
        self.present(resultPage, animated: true, completion: nil)
        
    }


}

