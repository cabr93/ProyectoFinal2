//
//  InterfaceController.swift
//  ProyectoFinal1W Extension
//
//  Created by Carlos Buitrago on 19/04/16.
//  Copyright © 2016 Carlos Buitrago. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    var watchSession : WCSession?
    var ventana = MKCoordinateSpanMake(0.005, 0.005)
    
    @IBOutlet var ima: WKInterfaceImage!
    @IBOutlet var mapa: WKInterfaceMap!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }
    @IBAction func hacerZoom(value: Float) {
        let grados:CLLocationDegrees = CLLocationDegrees(value)/10
        ventana = MKCoordinateSpanMake(grados, grados)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if(WCSession.isSupported()){
            watchSession = WCSession.defaultSession()
            // Add self as a delegate of the session so we can handle messages
            watchSession!.delegate = self
            watchSession!.activateSession()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        let puntos : Array<Array<String>> = applicationContext["message"] as! Array<Array<String>>
        for var i = 0; i < puntos.count; i++ {
            let tec = CLLocationCoordinate2D(latitude: Double(puntos[i][0])!, longitude: Double(puntos[i][1])!)
            self.mapa.addAnnotation(tec, withPinColor: .Purple)
            let region = MKCoordinateRegionMake(tec, ventana)
            mapa.setRegion(region)
        }
        
    }

}
