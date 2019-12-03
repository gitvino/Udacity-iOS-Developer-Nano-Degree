//
//  HomeTabViewController.swift
//  On The Map
//
//  Created by Vinoth kumar on 25/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import UIKit

class HomeTabViewController: UITabBarController {
    
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
    @IBAction func addLocationPressed(_ sender: Any) {
        
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.udacityUser = nil
        UdacityClient.sharedInstance().logout {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func reloadPressed(_ sender: Any) {
        
        if let viewControllers = self.viewControllers {
            
            switch self.selectedIndex {
                case 0:
                    let vc = viewControllers[self.selectedIndex] as! MapViewController
                    vc.reloadData()
                    break
                case 1:
                    let vc = viewControllers[self.selectedIndex] as! ListViewController
                    vc.reloadData()
                    break
                default:
                    return
            }
        }
        
    }
    
    

}
