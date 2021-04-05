//
//  InformationPostingViewController.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 04/04/2021.
//

import UIKit

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationTextField.text = ""
        linkTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Location"
        // Disable auto correct on text fields
        locationTextField.autocorrectionType = .no
        linkTextField.autocorrectionType = .no
        // Set left padding
        locationTextField.setLeftPaddingPoints(10.0)
        linkTextField.setLeftPaddingPoints(10.0)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        // Add a cancel button
        self.navigationItem.leftBarButtonItem = cancelButton
        // check if previous student locations were posted
        checkLocationOverwrite()
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        // Do a check if either the link or the location text fields are empty
        if locationTextField.isEmpty || linkTextField.isEmpty {
            // Either of the text fields are empty
            let alertViewController = UIAlertController(title: nil, message: "Location or link not set. Please enter a location and link.", preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
        } else {
            let informationPostingMapViewController = self.storyboard?.instantiateViewController(identifier: "InformationPostingMapViewController") as! InformationPostingMapViewController
            informationPostingMapViewController.locationNaturalLanguageQuery = locationTextField.text
            informationPostingMapViewController.mediaURL = linkTextField.text
            self.navigationController?.pushViewController(informationPostingMapViewController, animated: true)
        }
    }
    
    @objc func cancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkLocationOverwrite() {
        // Check if the current user has already posted locations. If yes, we prompt the user to overwrite
        // his last posted location. This is for simplicity. Ideally, we should present a table view with a single choice
        // to let the user choose which previous student location he wishes to overwrite.
        OnTheMapClient.getCurrentUserPostedStudentLocation { (studentInformation, error) in
            if let studentInformation = studentInformation {
                self.showOverwritePrompt(studentInformation: studentInformation)
            }
        }
    }
    
    func showOverwritePrompt(studentInformation: StudentInformation) {
        let alertViewController = UIAlertController(title: nil, message: "You have already posted a student location. Would you like to overwrite your last posted location ?", preferredStyle: .alert)
        // Action if user wishes to overwrite his last location
        alertViewController.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { action in
            // Return control back to the Add location page and set the details
            DispatchQueue.main.async {
                // Populate the link and last edited location
                self.locationTextField.text = studentInformation.mapString
                self.linkTextField.text = studentInformation.mediaURL
            }
            // Set the isPOST value to false and user would like to overwrite
            StudentLocationModel.lastLocationInformation = studentInformation
        }))
        // Action if user cancels his request
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
}
