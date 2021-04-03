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
    
    
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        OnTheMapClient.createSessionId(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginTappedResponse(success:error:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

