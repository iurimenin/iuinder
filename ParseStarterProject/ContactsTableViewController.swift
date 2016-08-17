//
//  ContactsTableViewController.swift
//  ParseStarterProject
//
//  Created by Iuri Menin on 16/08/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ContactsTableViewController: UITableViewController {

    var emails = [String]()
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()!
        
//        query.whereKey("accepted", equalTo: PFUser.currentUser()!.objectId!)
//        query.whereKey("objectId", containedIn: PFUser.currentUser()?["accepted"] as! [String])

        query.whereKey("accepted", equalTo: "8SzwKXE5wo")
        query.whereKey("objectId", containedIn: ["8SzwKXE5wo"])
        
        query.findObjectsInBackgroundWithBlock { (results, error) in
            
            if let results = results {
                
                
                for result in results as! [PFUser]{
                    self.emails.append(result["email"]! as! String)
                    
                    let imageFile = result["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock({ (data, error) in
                        
                        if error != nil {
                            print(error)
                        } else {
                            
                            if let imageData = data {
                                self.images.append(UIImage(data: imageData)!)
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
                
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text =  emails[indexPath.row]

        if images.count > indexPath.row {
            cell.imageView?.image = images[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = NSURL(string: "mailto:" + emails[indexPath.row])
        UIApplication.sharedApplication().openURL(url!)
    }
}
