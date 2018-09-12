//
//  MapTabViewController.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 9/6/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit

protocol MapTabBarDelegate {
    func pressedRefresh()
}

class MapTabViewController: UITabBarController {
    
    var mapTabBarDelegate : MapTabBarDelegate?
    var appDelegate : AppDelegate!
    
    @IBAction func pressedRefresh(_ sender: UIBarButtonItem) {
        mapTabBarDelegate?.pressedRefresh()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
            
        if let userId = appDelegate.userId {
            
            NetworkClient.shared.doGetUser(userId: userId) { (data, error) in
                if error != nil {
                    self.displayAlert(title: "Error", message: error!)
                } else {
                   
                    guard let users = data!["results"] as? [[String:AnyObject]] else {
                        self.displayError("No results was returned by the request!")
                        return
                    }

                    if users.isEmpty {

                        // Create a new one if user Id not found
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddItemViewController") as! UINavigationController
                        let rootController = controller.topViewController as! AddItemViewController

                        rootController.newLocation = true
                        self.present(controller, animated: true, completion: nil)

                    } else {

                        guard let objectId = users[0]["objectId"] as? String else {
                            self.displayError("No data was returned by the request!")
                            return
                        }
                        self.appDelegate.objectId = objectId
                        self.displayAlertChallenge(title: "Location Exists", message: "Overwrite existing location?")
                        
                    }
                }
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
    
        NetworkClient.shared.doLogout { (data, error) in
            if error != nil {
                self.displayAlert(title: "Error", message: error!)
            } else {
             
                guard let session = data![Constants.ACCOUNT.Session] as? [String:AnyObject] else {
                    self.displayError("No results was returned by the request!")
                    return
                }
    
                guard let _ = session[Constants.ACCOUNT.Id] as? String else {
                    self.displayError("Failed to logout!")
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate

    }
    func displayError(_ message: String) {
        performUIUpdatesOnMain {
            self.displayAlert(title: "Error", message: message)
        }
    }
    
    func displayAlert(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func displayAlertChallenge(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { UIAlertAction in
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddItemViewController") as! UINavigationController
            let rootController = controller.topViewController as! AddItemViewController
            rootController.newLocation = false
            self.present(controller, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
