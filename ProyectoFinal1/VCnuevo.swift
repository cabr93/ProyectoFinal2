//
//  VCnuevo.swift
//  ProyectoFinal1
//
//  Created by Carlos Buitrago on 20/04/16.
//  Copyright © 2016 Carlos Buitrago. All rights reserved.
//

import UIKit
import CoreData

@objc protocol PasarInfo {
    func ruta(nombre: String, descripcion: String, imagen:UIImage)
}

class VCnuevo: UIViewController,UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var ima: UIImageView!
    @IBOutlet weak var BTF: UIButton!
    @IBOutlet weak var BAF: UIButton!
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var ldescripcion: UILabel!
    @IBOutlet weak var guardar: UIBarButtonItem!
    //camara
    private var miPicker = UIImagePickerController()
    //CoreData
    var contexto : NSManagedObjectContext? = nil
    var delegate: PasarInfo?
    var codigo = ""
    //variables
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        guardar.enabled = false
        ldescripcion.hidden = true
        descripcion.hidden = true
        BAF.hidden = true
        BTF.hidden = true
        ima.hidden = true
        flag = false
        
        if !UIImagePickerController.isSourceTypeAvailable(.Camera){
            flag = true
        }
        miPicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func descripcion(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func nombre(sender: UITextField) {
        sender.resignFirstResponder()
        if sender.text == ""{
            guardar.enabled = false
            ldescripcion.hidden = true
            descripcion.hidden = true
            BAF.hidden = true
            BTF.hidden = true
            ima.hidden = true
        }
        else{
            guardar.enabled = true
            ldescripcion.hidden = false
            descripcion.hidden = false
            BAF.hidden = false
            ima.hidden = false
            if !flag {
                BTF.hidden = false
            }
        }
    }
    @IBAction func listo(sender: UIBarButtonItem) {
        var imag :UIImage
        if ima.image == nil{
            imag = UIImage(named: "blanco.png")!
        }
        else{
            imag = ima.image!
        }
        self.delegate?.ruta(nombre.text!, descripcion: descripcion.text!,imagen:imag)
        let nuevaSeccionEntidad = NSEntityDescription.insertNewObjectForEntityForName("Ruta", inManagedObjectContext: self.contexto!)
        nuevaSeccionEntidad.setValue(nombre.text, forKey: "nombre")
        nuevaSeccionEntidad.setValue(descripcion.text, forKey: "descripcion")
        nuevaSeccionEntidad.setValue(UIImagePNGRepresentation(imag), forKey: "foto")
        do{
            try self.contexto?.save()
        }
        catch{
            
        }
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func backGroundTap(sender:UIControl){
        nombre.resignFirstResponder()
        descripcion.resignFirstResponder()
    }
    
    
    @IBAction func camara() {
        miPicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(miPicker, animated: true, completion: nil)
    }
    @IBAction func album() {
        miPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(miPicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        ima.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
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
