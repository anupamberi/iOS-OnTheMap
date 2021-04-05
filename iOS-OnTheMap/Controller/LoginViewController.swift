//
//  ViewController.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 29/03/2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable auto correct on text fields
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        // Set left padding
        emailTextField.setLeftPaddingPoints(10.0)
        passwordTextField.setLeftPaddingPoints(10.0)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if emailTextField.isEmpty || passwordTextField.isEmpty {
            // Either of the text fields are empty
            let alertViewController = UIAlertController(title: nil, message: "Username and/or password not set. Please enter a username and a password.", preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
        } else {
            setLoggingIn(true)
            OnTheMapClient.createSessionId(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginTappedResponse(success:error:))
        }
    }

    func handleLoginTappedResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            print(OnTheMapClient.Auth.uniqueKey)
            print(OnTheMapClient.Auth.sessionId)
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

