//
//  VCMapaDos.swift
//  ProyectoFinal1
//
//  Created by Carlos Buitrago on 21/04/16.
//  Copyright © 2016 Carlos Buitrago. All rights reserved.
//

import UIKit
import MapKit
import WatchConnectivity


class VCMapaDos: UIViewController, MKMapViewDelegate, WCSessionDelegate {
    
    @IBOutlet weak var mapaRuta: MKMapView!
    
    private var origen: MKMapItem!
    private var destino : MKMapItem!
    private var unoMas :MKMapItem!
    private var otro :MKMapItem!
    private var anterior :MKMapItem!
    
    var watchSession : WCSession?
    
    
    var puntos :Array<Array<String>> = Array<Array<String>>()
    var punto = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapaRuta.delegate = self
        for var i = 0; i < puntos.count; i++ {
            let puntocoor2 = CLLocationCoordinate2D(latitude: Double(puntos[i][0])!, longitude: Double(puntos[i][1])!)
            let puntoLugar2 = MKPlacemark(coordinate: puntocoor2, addressDictionary: nil)
            otro = MKMapItem(placemark: puntoLugar2)
            let pin = MKPointAnnotation()
            pin.title = puntos[i][2]
            pin.subtitle = puntos[i][3]
            pin.coordinate = otro.placemark.coordinate
            mapaRuta.addAnnotation(pin)
            if i > 0{
                self.obtenerRuta(self.otro!, destino:self.anterior!)
            }
            anterior = MKMapItem(placemark: puntoLugar2)
        }
        let centro = otro.placemark.coordinate
        let region = MKCoordinateRegionMakeWithDistance(centro, 500, 500)
        mapaRuta.setRegion(region, animated: true)
        if(WCSession.isSupported()){
            watchSession = WCSession.defaultSession()
            watchSession!.delegate = self
            watchSession!.activateSession()
        }
    }
    func obtenerRuta(origen:MKMapItem, destino:MKMapItem){
        let solicitud = MKDirectionsRequest()
        solicitud.source = origen
        solicitud.destination = destino
        solicitud.transportType = .Walking
        let indicaciones = MKDirections(request: solicitud)
        indicaciones.calculateDirectionsWithCompletionHandler({
            (respuesta:MKDirectionsResponse?, error : NSError?) in if error != nil{
                print("error obtener ruta")
            }
            else{
                self.muestraRuta(respuesta!)
            }
        })
    }
    func muestraRuta(respuesta: MKDirectionsResponse){
        for ruta in respuesta.routes{
            mapaRuta.addOverlay(ruta.polyline, level: MKOverlayLevel.AboveRoads)
            for paso in ruta.steps{
                print(paso.instructions)
            }
        }
    }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 0, green: 131/255, blue: 1, alpha: 1)
        renderer.lineWidth = 6.0
        return renderer
    }
    @IBAction func enviarW(sender: AnyObject) {
        do {
            try watchSession?.updateApplicationContext(
                ["message" : puntos]
            )
        } catch let error as NSError {
            NSLog("Updating the context failed: " + error.localizedDescription)
        }
    }
}
