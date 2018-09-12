//
//  MapTableViewController.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 8/30/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit

class MapTableViewController: UITableViewController {

    var appDelegate : AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarVC = self.tabBarController as? MapTabViewController
        tabBarVC?.mapTabBarDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        downloadLocationData()
    }
    
    // Get student locations from parse server
    private func downloadLocationData() {
        
        NetworkClient.shared.doGetStudentLocations { (data, error) in
            if error != nil {
                
                self.displayAlert(title: "Error", message: error!)
                
            } else {
                
                guard let studentArray = data!["results"] as? [[String:AnyObject]] else {
                    self.displayError("No data was returned by the request!")
                    return
                }
    
                Model.shradeInstance.updateModel(studentArray)
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shradeInstance.studentLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnTheMapIdentifier", for: indexPath)

        //let dictionary = students[indexPath.row] as Dictionary
        
        let student = Model.shradeInstance.studentLocations[indexPath.row]
        
        if let firstname = student.firstname, let lastname = student.lastname, let mediaURL = student.mediaURL {
            cell.textLabel?.text = "\(firstname) \(lastname)"
            cell.detailTextLabel?.text = "\(mediaURL)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let student = Model.shradeInstance.studentLocations[indexPath.row]
        if let pathString = student.mediaURL {
           
            let pathHTTPS = "https://\(pathString)"
            
            if app.canOpenURL(URL(string: pathString)!) {
                app.open(URL(string: pathString)!, options: [:])
            } else if app.canOpenURL(URL(string: pathHTTPS)!) {
                app.open(URL(string: pathHTTPS)!, options: [:])
            }
        }
    }
    
    //MARK: - Error Alert
    func displayError(_ message: String) {
        performUIUpdatesOnMain {
            self.displayAlert(title: "Error", message: message)
        }
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
    
    func displayAlert(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

// Refresh pressed from tab bar VC
extension MapTableViewController: MapTabBarDelegate {
    
    func pressedRefresh() {
        print("Refresh Executed")
        downloadLocationData()
    }
}
