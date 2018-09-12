//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 8/30/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var appDelegate : AppDelegate!
    
    @IBOutlet weak var mapView: MKMapView!

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
    
    // Get student locations from parse
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
                self.getLocations()
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

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    // Process student location array and load into the annotation array
    private func getLocations() {
        
        var annotations = [MKPointAnnotation]()

        for student in Model.shradeInstance.studentLocations {
            
            guard let latitude  = student.latitude else { continue }
            guard let longitude = student.longitude else { continue }
            
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            
            guard let firstname = student.firstname else { continue }
            guard let lastname  = student.lastname else { continue }
            guard let mediaURL  = student.mediaURL else { continue }
        
            let annotation = MKPointAnnotation()
                
            annotation.coordinate = coordinate
            annotation.title = "\(firstname) \(lastname)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor   = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let pathString = view.annotation?.subtitle! {
                
                let pathHTTPS = "https://\(pathString)"
                
                if app.canOpenURL(URL(string: pathString)!) {
                    app.open(URL(string: pathString)!, options: [:])
                } else if app.canOpenURL(URL(string: pathHTTPS)!) {
                    app.open(URL(string: pathHTTPS)!, options: [:])
                }
            }
        }
    }
}

// Refresh pressed from tab bar VC
extension MapViewController: MapTabBarDelegate {

    func pressedRefresh() {
        print("Refresh Executed")
        downloadLocationData()
    }
}
