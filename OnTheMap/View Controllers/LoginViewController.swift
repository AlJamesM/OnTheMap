//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 8/24/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var appDelegate : AppDelegate!
    
    //MARK: - Outlets
    @IBOutlet weak var onTheMapImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = CGFloat(Constants.UI.Button.CornerRadius)
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapBackView))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Close keyboard
    @objc func tapBackView() {
        resignResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func pressedEnter(_ sender: UITextField) {
        resignResponder()
    }
    
    // Open Udacity Sign-up page in Safari
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let app = UIApplication.shared
        app.open(URL(string: Constants.UDACITY.SignUpPage)!, options: [:])
    }
    
    //MARK: - Login Methods
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            
            displayAlert(title: "Error", message: "Username of Password Empty")
            
        } else {
            
            getUserId()
            
        }
    }
    
    // Login after user account info is available
    private func loginComplete() {
            
        self.activityIndicator.isHidden = true
        self.enableUI(true)
        
        usernameTextField.text = ""
        passwordTextField.text = ""
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnTheMapNavController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }

    // Get user id from Udacity
    private func getUserId() {
        
        // Start Spinner
        self.activityIndicator.isHidden = false
        self.enableUI(false)
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            displayAlert(title: "Error", message: "Username of Password Invalid")
            return
        }
        
        NetworkClient.shared.doGetUserId(username: username, password: password) { (data, error) in
            if error != nil {
                
                self.displayAlert(title: "Login Fail", message: error!)
                
            }else {
                
                guard let session = data![Constants.ACCOUNT.AccountKey] as? [String:AnyObject] else {
                    self.displayError("Could not parse the Account data.")
                    return
                }
                
                guard let userId = session[Constants.ACCOUNT.KeyKey] as? String else {
                    self.displayError("Could not parse the User ID data.")
                        return
                    }
                
                self.appDelegate.userId = userId
                self.getUserData(userId)
                print(userId)
            }
        }
    }
    
    // Using user id, get user account info from Udacity
    private func getUserData(_ userId: String) {
        
        NetworkClient.shared.doGetUserInformation(userId: userId) { (data, error) in
            if error != nil {
                
                self.displayAlert(title: "Login Fail", message: error!)
                
            } else {
                
                guard let user = data![Constants.ACCOUNT.UserKey] as? [String:AnyObject] else {
                    self.displayError("Could not get user data.")
                    return
                }
                
                guard let firstName = user[Constants.ACCOUNT.FirstnameKey] as? String else {
                    self.displayError("Could not get first name.")
                    return
                }
                
                guard let lastName = user[Constants.ACCOUNT.LastnameKey] as? String else {
                    self.displayError("Could not get last name.")
                    return
                }
                
                self.appDelegate.firstName = firstName
                self.appDelegate.lastName  = lastName
                
                self.loginComplete()
            }
        }
    }
}

// MARK: - Notifications
private extension LoginViewController {
    
    func enableUI (_ enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled       = enabled

        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func displayError(_ message: String) {
        self.displayAlert(title: "Error", message: message)
    }
    
    func displayAlert(title : String, message: String) {
        
        self.activityIndicator.isHidden = true
        self.enableUI(true)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func resignResponder() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
