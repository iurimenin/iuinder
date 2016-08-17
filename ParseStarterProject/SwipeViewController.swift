//
//  SwipeViewController.swift
//  ParseStarterProject
//
//  Created by Iuri Menin on 16/08/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class SwipeViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!

    var displeyedUserId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(SwipeViewController.wasDragged(_:)))
        userImage.addGestureRecognizer(gesture)
        userImage.userInteractionEnabled = true

        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint? , error: NSError?) in
        
            if let geopoint = geopoint {
                
                PFUser.currentUser()?["location"] = geopoint
                PFUser.currentUser()?.save()
                
                let query = PFUser.query()!
                query.findObjectsInBackgroundWithBlock({ (ob: [AnyObject]?, error: NSError?) in
                    
                    for o in ob! as [AnyObject] {
                        
                        let a = o as! PFUser
                        print(a)
                        a["location"] = geopoint
                        a["accepted"] = PFUser.currentUser()?.objectId
                        a.saveInBackgroundWithBlock({ (su, error) in
                            print(su)
                        })
                    }
                })
            }
        }
        
        updateImage()
    }
    
    func updateImage() {
        
        let query = PFUser.query()!
        
        if let latitude = PFUser.currentUser()?["location"]?.latitude {
         
            if let longitude = PFUser.currentUser()?["location"]?.longitude {
                
                query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1, longitude: longitude + 1))
            }
        }
        
        var interestedIn = "male"
        
        if PFUser.currentUser()?["interestedInWoman"] as? Bool == true {
            
            interestedIn = "female"
        }
        
        var isFemale = true
        
        if PFUser.currentUser()?["gender"] as? String == "male" {
            
            isFemale = false
        }
        
        query.whereKey("gender", equalTo: interestedIn)
        query.whereKey("interestedInWoman", equalTo: isFemale)
        
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.currentUser()?["accepted"] {
            
            ignoredUsers += acceptedUsers as! Array
        }
        
        if let rejectedUsers = PFUser.currentUser()?["rejected"] {
            
            ignoredUsers += rejectedUsers as! Array
        }
        
        query.whereKey("objectId", notContainedIn: ignoredUsers)
        
        query.limit = 1
        
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) in
            
            if error != nil {
                print(error)
            } else if let objects = objects as? [PFObject] {
                
                for object in objects {
                    
                    self.displeyedUserId = object.objectId!
                    let imageFile = object["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock({ (data, error) in
                        
                        if error != nil {
                            print(error)
                        } else {
                            
                            if let imageData = data {
                                self.userImage.image = UIImage(data: imageData)
                            }
                        }
                    })
                }
            }
        })
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        
        let label = gesture.view!
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            if label.center.x < 100 {
                acceptedOrRejected = "rejected"
            } else if label.center.x > self.view.bounds.width - 100 {
                acceptedOrRejected = "accepted"
            }
            
            if acceptedOrRejected != "" {
            
                PFUser.currentUser()?.addUniqueObjectsFromArray([displeyedUserId], forKey: acceptedOrRejected)
                PFUser.currentUser()?.save()
            }
            
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            label.transform = stretch
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            updateImage()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logout" {
            PFUser.logOut()
        }
    }
}
