//
//  ViewController.swift
//  motionAuthentication
//
//  Created by Nwamaka Nzeocha on 10/20/15.
//  Copyright © 2015 Nwamaka Nzeocha. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreMotion

class ViewController: UIViewController, WCSessionDelegate {
    
    var session: WCSession!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!

    @IBAction func sendMessageButton(sender: AnyObject) {
        //Send message to WatchKit
        let messageToSend = ["value": "Hi watch, can you talk to me?"]
        session.sendMessage(messageToSend, replyHandler: { replyMessage in
            //handle the reply
            let value = replyMessage["value"] as? String
            //use dispatch_asynch to present immediately on screen
            dispatch_async(dispatch_get_main_queue()) {
                self.messageLabel.text = value
            }
            }, errorHandler: {error in
                // catch any errors here
                print(error)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        //handle received message
        let value = message["value"] as? String
        dispatch_async(dispatch_get_main_queue()) {
            self.messageLabel.text = value
        }
        //send a reply
        replyHandler(["Value":"Hello Watch"])
    }


}

