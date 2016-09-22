//
//  CatxTabBarController.swift
//  Catenaxio
//
//  Created by Hugh on 19/07/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import UIKit

class CatxTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Empiezo mi controller tab bar");
        // Do any additional setup after loading the view.
        UITabBar.appearance().tintColor = UIColor(red: 48/255, green: 67/255, blue: 74/255, alpha: 1)
        
        // Sets the default color of the background of the UITabBar
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
