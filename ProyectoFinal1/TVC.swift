//
//  TVC.swift
//  ProyectoFinal1
//
//  Created by Carlos Buitrago on 20/04/16.
//  Copyright © 2016 Carlos Buitrago. All rights reserved.
//

import UIKit
import CoreData

class TVC: UITableViewController, UITextFieldDelegate,PasarInfo  {
    
    var rutas :Array<Array<String>> = Array<Array<String>>()
    var imagenes: Array<UIImage> = Array<UIImage>()
    var contexto:NSManagedObjectContext? = nil
    var flag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let seccionEntidad = NSEntityDescription.entityForName("Ruta", inManagedObjectContext: self.contexto!)
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("petSecciones")
        do{
            let seccionesEntidad = try self.contexto?.executeFetchRequest(peticion!)
            for seccionesEntidad2 in seccionesEntidad!{
                let nombre = seccionesEntidad2.valueForKey("nombre") as! String
                let descripcion = seccionesEntidad2.valueForKey("descripcion") as! String
                let imagen = UIImage(data: seccionesEntidad2.valueForKey("foto") as! NSData)
                self.rutas.append([nombre,descripcion])
                self.imagenes.append(imagen!)
            }
        }
        catch{
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        flag = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.rutas.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celda", forIndexPath: indexPath)
        
        // Configure the cell...
        
        cell.textLabel?.text = self.rutas[indexPath.row][0]
        cell.detailTextLabel?.text = self.rutas[indexPath.row][1]
        cell.imageView!.image = self.imagenes[indexPath.row]
        return cell
    }
    func ruta(nombre: String, descripcion: String, imagen:UIImage){
        rutas.append([nombre ,descripcion])
        imagenes.append(imagen)
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([
            NSIndexPath(forRow: rutas.count-1, inSection: 0)
            ], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
        
    }

    
    @IBAction func agregarR(sender: AnyObject) {
        flag = false
        performSegueWithIdentifier("addr", sender: sender)
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if !flag {
            let cc = segue.destinationViewController as! VCnuevo
            cc.delegate = self
        }
        else{
        }
    }


}
