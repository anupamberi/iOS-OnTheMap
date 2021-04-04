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
        
        locationTextField.autocorrectionType = .no
        linkTextField.autocorrectionType = .no
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        let informationPostingMapViewController = self.storyboard?.instantiateViewController(identifier: "InformationPostingMapViewController") as! InformationPostingMapViewController
        informationPostingMapViewController.locationNaturalLanguageQuery = locationTextField.text
        informationPostingMapViewController.mediaURL = linkTextField.text
        self.navigationController?.pushViewController(informationPostingMapViewController, animated: true)
    }
    
    @objc func cancelTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
