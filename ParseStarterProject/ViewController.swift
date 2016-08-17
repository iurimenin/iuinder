//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBAction func signIn(sender: AnyObject) {
        
        let permissions = ["public_profile", "email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user: PFUser?, error: NSError?) -> Void in
            
            if let error = error {
                
                print(error)
                
            } else {
                
                if let user = user {
                    
                    if user["interestedInWoman"] != nil {
                        self.performSegueWithIdentifier("logUserIn", sender: self)
                    } else {
                        self.performSegueWithIdentifier("showSigninScreen", sender: self)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        let urlArray = ["http://www.thezerosbeforetheone.com/wordpress/wp-content/uploads/2011/07/smurfette-300x225.gif",
//            "http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=44643840",
//            "http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=62956603",
//            "http://static.comicvine.com/uploads/square_small/0/2617/103863-63963-torongo-leela.JPG",
//            "http://www.theunknownpen.com/wp-content/uploads/2013/03/Velma.jpg",
//            "http://assets.makers.com/styles/mobile_gallery/s3/betty-boop-cartoon-576km071213_0.jpg?itok=9qNg6GUd",
//            "http://magicdisneyheros.altervista.org/images/midl/97.jpg"]
//        
//        var counter = 1
//        
//        for url in urlArray {
//            
//            let nsURL = NSURL(string: url)!
//            
//            if let data = NSData(contentsOfURL: nsURL) {
//                
//                let imageFile:PFFile = PFFile(data: data)
//                var user:PFUser = PFUser()
//                
//                user.username = "user\(counter)"
//                user.password = "secret"
//                user["image"] = imageFile
//                user["interestedInWoman"] = false
//                user["gender"] = "female"
//                
//                counter++
//                
//                user.signUp()
//                
//            }
//            
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if (PFUser.currentUser()?.username) != nil {
            
            if (PFUser.currentUser()?["interestedInWoman"]) != nil {
                self.performSegueWithIdentifier("logUserIn", sender: self)
            } else {
                self.performSegueWithIdentifier("showSigninScreen", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

