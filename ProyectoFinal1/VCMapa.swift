//
//  VCMapa.swift
//  ProyectoFinal1
//
//  Created by Carlos Buitrago on 21/04/16.
//  Copyright © 2016 Carlos Buitrago. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class VCMapa: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate,MKMapViewDelegate  {
    @IBOutlet weak var MostrarRuta: UIBarButtonItem!
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var lugarN: UITextField!
    private let manejador = CLLocationManager()
    var punto = CLLocationCoordinate2D()
    var flag = false
    var flag2 = true
    var lugar = ""
    var posicion = 0
    var puntos :Array<Array<String>> = Array<Array<String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        posicion = 0
        MostrarRuta.enabled = false
        mapa.delegate = self
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        }else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapa.setRegion(region, animated: true)
        if flag {
            flag = false
            punto.latitude = location!.coordinate.latitude
            punto.longitude = location!.coordinate.longitude
            let pin = MKPointAnnotation()
            pin.title = String(lugar)
            pin.subtitle = "Posición" + String(posicion)
            pin.coordinate = punto
            mapa.addAnnotation(pin)
            add.enabled = false
            self.puntos.append([String(punto.latitude),String(punto.longitude),String(lugar),"Posición" + String(posicion)])
            posicion += 1
            if posicion > 1{
                MostrarRuta.enabled = true
            }
        }
    }
    @IBAction func Lugar(sender: UITextField) {
        sender.resignFirstResponder()
        add.enabled = true
        lugar = sender.text!
    }
    @IBAction func add(sender: UIBarButtonItem) {
        flag = true
        lugarN.text = ""
    }
    override func viewDidAppear(animated: Bool) {
        flag2 = true
    }
    @IBAction func agregarR(sender: AnyObject) {
        flag2 = false
        performSegueWithIdentifier("mapav", sender: sender)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if !flag2 {
            let cc = segue.destinationViewController as! VCMapaDos
            cc.puntos = puntos
        }
        else{
            print("g")
        }
    }
    //imagen de selccion
    /*
     func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
     let annotationReuseId = "Place"
     var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseId)
     if anView == nil {
     anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
     } else {
     anView!.annotation = annotation
     }
     anView!.image = UIImage(named: "QR.png")
     anView!.backgroundColor = UIColor.clearColor()
     anView!.canShowCallout = false
     return anView
     }
     */
}
