//
//  InterfaceController.swift
//  motionAuthentication WatchKit Extension
//
//  Created by Nwamaka Nzeocha on 10/20/15.
//  Copyright © 2015 Nwamaka Nzeocha. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var messageLabel: WKInterfaceLabel!
    @IBOutlet var readyGoButton: WKInterfaceButton!
    
    // create & configure a WCSession instance
    var session : WCSession!
    
    
    @IBAction func readyGoButtonPressed() {
        let messageToSend = ["value": "Hello iPhone"]
        session.sendMessage(messageToSend, replyHandler: { replyMessage in
            // handle and present the message on screen
            let value = replyMessage["value"] as? String
            self.messageLabel.setText(value)
            }
            , errorHandler: {error in
                //catch any errors here
                print(error)
        })
        
        //checking if Accelerometer is available
        let manager = CMMotionManager()
        if manager.accelerometerAvailable {
            
            //set the update interval
            manager.accelerometerUpdateInterval = 0.01
            
            //Starting Updates to “pull” Data
            //after this call, manager.accelerometerData is accessible at any time with the device’s current gyroscope data.
            manager.startAccelerometerUpdates()
            
            manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
                    data, error in
                    
            }
            
            
        }
    
    }
    
    
    //invoked when a message is received by counterpart...this handles the message on the iOS device.
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        //handle received message
        let value = message["value"] as? String
        //use this to present immediately on the screen
        dispatch_async(dispatch_get_main_queue()) {
            self.messageLabel.setText(value)
        }
        //send a reply
        replyHandler(["value": "Yes"])
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // check if WCSession class is supported on the device
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        } //watchOS 2 app is now able to send/receive messages :)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
