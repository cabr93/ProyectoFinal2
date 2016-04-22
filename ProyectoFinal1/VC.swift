//
//  VC.swift
//  ProyectoFinal1
//
//  Created by Carlos Buitrago on 19/04/16.
//  Copyright © 2016 Carlos Buitrago. All rights reserved.
//

import UIKit


class VC: UIViewController {
    
    @IBOutlet weak var dirreccion: UILabel!
    @IBOutlet weak var web: UIWebView!
    var urls : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dirreccion?.text = urls!
        let url = NSURL(string: urls!)
        let peticion = NSURLRequest(URL: url!)
        web.loadRequest(peticion)
        
        // Do any additional setup after loading the view.
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

