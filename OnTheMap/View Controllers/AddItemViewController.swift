//
//  AddItemViewController.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 8/31/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit
import MapKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var submitStackConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBOutlet weak var mapSearchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkAddressTextField: UITextField!
    
    @IBOutlet weak var activityIndicatorView: UIView!
    
    var newLocation  : Bool = false
    var appDelegate  : AppDelegate!
    var keyboardOnScreen = false
    var urlExtension : String! = nil
    var methodType   : String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        buttonsSetup()
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapMapView))

        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow , selector: #selector(keyboardDidShow ))
        subscribeToNotification(.UIKeyboardDidHide , selector: #selector(keyboardDidHide ))
        
        enableSubmit(false)
        enableSearch(true)
        activityIndicatorHidden(true)
    }
    
    @objc func tapMapView() {
        linkAddressTextField.resignFirstResponder()
        mapSearchTextField.resignFirstResponder()
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        submit()
    }
    
    
    @IBAction func submitEnterPressed(_ sender: UITextField) {
        submit()
    }
    
    @IBAction func dismissPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mapSearchEnterPressed(_ sender: UITextField) {
        mapSearch()
    }
    
    @IBAction func mapSearchButtonPressed(_ sender: UIButton) {
        mapSearch()
    }
    
    func submit() {
        
        linkAddressTextField.resignFirstResponder()
        enableSearch(false)
        enableSubmit(false)
        activityIndicatorHidden(false)
        
        guard let linkAddress = linkAddressTextField.text else {
            self.displayError("Address text field could be read.")
            return
        }
        
        guard !linkAddress.isEmpty else {
            self.displayError("Address text field is empty.")
            return
        }
        
        
        
        if newLocation {
            
            NetworkClient.shared.doPostStudentLocation(userId: appDelegate.userId, firstName: appDelegate.firstName, lastName: appDelegate.lastName, locationName: appDelegate.locationName, linkAddress: linkAddress, latitude: appDelegate.latitude, longitude: appDelegate.longitude) { (data, error) in
                if error != nil {
                    self.displayAlert(title: "Error", message: error!)
                    self.enableSubmit(true)
                    self.enableSearch(true)
                    self.activityIndicatorHidden(true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            
            NetworkClient.shared.doPutStudentLocation(objectId: appDelegate.objectId, userId: appDelegate.userId, firstName: appDelegate.firstName, lastName: appDelegate.lastName, locationName: appDelegate.locationName, linkAddress: linkAddress, latitude: appDelegate.latitude, longitude: appDelegate.longitude) { (data, error) in
                if error != nil {
                    self.displayAlert(title: "Error", message: error!)
                    self.enableSubmit(true)
                    self.enableSearch(true)
                    self.activityIndicatorHidden(true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func mapSearch() {
        
        enableSubmit(false)
        enableSearch(false)
        activityIndicatorHidden(false)
        
        if let searchString = mapSearchTextField.text {
            
            guard (!searchString.isEmpty) else {
                self.displayError("Search text field is empty.")
                return
            }
            
            
            let searchRequest = MKLocalSearchRequest()
            
            searchRequest.naturalLanguageQuery = searchString
            searchRequest.region = mapView.region
            
            let locationSearch = MKLocalSearch(request: searchRequest)
            
            locationSearch.start(completionHandler: {(response, error) in
                
                if let err = error {

                    self.displayError("Error occured in search: \(err.localizedDescription)")

                } else {

                    if let results = response {
                            
                        if results.mapItems.count == 0 {
                          
                            self.displayError("No matches found")
                        
                        } else {
                                
                            let item = results.mapItems[0]
                            let annotation = MKPointAnnotation()
                                
                            annotation.coordinate = item.placemark.coordinate
                            annotation.title      = item.name
                                
                            self.appDelegate.locationName = item.name
                            self.appDelegate.latitude     = item.placemark.coordinate.latitude
                            self.appDelegate.longitude    = item.placemark.coordinate.longitude
                                
                            performUIUpdatesOnMain {
                                    
                                self.mapView.removeAnnotations(self.mapView.annotations)
                                
                                self.mapView.addAnnotation(annotation)
                                self.mapView.setCenter(annotation.coordinate, animated: true)
                                    
                                let span   = MKCoordinateSpanMake(Constants.UI.Map.Span, Constants.UI.Map.Span)
                                let region = MKCoordinateRegionMake(annotation.coordinate, span)
                                    
                                self.mapView.setRegion(region, animated: true)
                                    
                                self.enableSubmit(true)
                                self.enableSearch(true)
                                self.activityIndicatorHidden(true)
                            }
                        }
                    }
                }
            })
        }
    }
    
    func activityIndicatorHidden(_ status: Bool) {
        activityIndicatorView.isHidden  = status
    }
    
    //MARK: - Error Alert
    func displayError(_ message: String) {
        performUIUpdatesOnMain {
            self.linkAddressTextField.resignFirstResponder()
            self.mapSearchTextField.resignFirstResponder()
            self.displayAlert(title: "Error", message: message)
        }
    }
    
    func displayAlert(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func buttonsSetup() {
        searchButton.layer.cornerRadius = CGFloat(Constants.UI.Button.CornerRadius)
        submitButton.layer.cornerRadius = CGFloat(Constants.UI.Button.CornerRadius)
    }
    
    //MARK: - Notification
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }

    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - UI
    private func enableSubmit(_ enable: Bool) {
        submitButton.isEnabled         = enable
        linkAddressTextField.isEnabled = enable
        if enable {
            // Visible
            UIView.animate(withDuration: 0.3) {
                self.submitButton.alpha         = 1
                self.linkAddressTextField.alpha = 1
            }
        } else {
            // Hide
            UIView.animate(withDuration: 0.1) {
                self.submitButton.alpha         = 0
                self.linkAddressTextField.alpha = 0
            }
        }
    }
    
    private func enableSearch(_ enable: Bool) {
        searchButton.isEnabled       = enable
        mapSearchTextField.isEnabled = enable
        if enable {
            // Visible
            UIView.animate(withDuration: 0.3) {
                self.searchButton.alpha       = 1
                self.mapSearchTextField.alpha = 1
            }
        } else {
            //Hide
            UIView.animate(withDuration: 0.1) {
                self.searchButton.alpha       = 0
                self.mapSearchTextField.alpha = 0
            }
        }
    }
}

// MARK: - Text Field Delegate
extension  AddItemViewController: UITextFieldDelegate {

    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            bottomStackView.frame.origin.y -= keyboardHeight(notification)
            self.submitStackConstraint.constant = self.keyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            bottomStackView.frame.origin.y += keyboardHeight(notification)
            self.submitStackConstraint.constant = 0
        }
    }

    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }

    @objc func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }

    private func keyboardHeight(_ notification: Notification) -> CGFloat {

        let userInfo     = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height

    }
}

extension AddItemViewController: MKMapViewDelegate {

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
}
