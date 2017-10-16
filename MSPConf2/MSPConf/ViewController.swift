//
//  ViewController.swift
//  MSPConf
//
//  Created by Sorawit on 10/14/17.
//  Copyright © 2017 Sorawit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var msp = MSP()
    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var commandView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendCommand(){
//        while(true){
//             msp.takeOff()
//        }
       
        
        
        msp.writeValue(data: "$")
        msp.writeValue(data: "M")
        msp.writeValue(data: "<")
        msp.writeValue(data: "\0")
        msp.writeValue(data: "d")
        msp.writeValue(data: "d")
        
        //myPort.write();
    }
    
    
    @IBAction func sendCommand2(){
        //        while(true){
        //             msp.takeOff()
        //        }
        
        
        
        msp.writeValue(data: "$")
        msp.writeValue(data: "M")
        msp.writeValue(data: "<")
        msp.writeValue(data: "\0")
        msp.writeValue(data: "f")
        msp.writeValue(data: "f")
        
        //myPort.write();
    }
    
    @IBAction func getRespone(){
        commandView.text = msp.str
    }
    

}

