//
//  TableViewController.swift
//  iosbrowser-swift
//
//  Created by Użytkownik Gość on 27.10.2016.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let plistCatPath = NSBundle.mainBundle().pathForResource("albums", ofType: "plist");
    var albums: NSMutableArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albums = NSMutableArray(contentsOfFile:plistCatPath!);
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albums!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID", forIndexPath: indexPath)

        let album = self.albums![indexPath.row] as! NSMutableDictionary;
        
       
        cell.textLabel?.text = album.valueForKey("artist") as? String;
        cell.detailTextLabel?.text = album.valueForKey("title") as? String;
        
        
        // Configure the cell...

        return cell
    }
    

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

    @IBAction func unwindToTable(segue: UIStoryboardSegue){
        let viewController = segue.sourceViewController as! ViewController;
        albums = viewController.albums;
        
        self.tableView.reloadData();
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let viewController = segue.destinationViewController as! ViewController
        
        if segue.identifier == "detail" {
            let row = self.tableView.indexPathForSelectedRow!.row;
            viewController.apiEditElement = true;
            viewController.apiEditRow = row;
            viewController.albums = albums;
          
     
        }
        else if segue.identifier == "add" {
            viewController.apiNewElement = true;
            viewController.newElement();
            viewController.albums = albums;
            
        }
        
     //   let viewController:ViewController = segue!.destinationViewController as ViewController
     //   let indexPath = self.tableView.indexPathForSelectedRow()
     //   viewController.pinCode = self.exams[indexPath.row]
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
