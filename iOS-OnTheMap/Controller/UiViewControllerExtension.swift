//
//  UiViewControllerExtension.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 03/04/2021.
//
import UIKit

extension UIViewController {
    
    @objc func logoutTapped(_ sender: UIBarButtonItem) {
        StudentLocationModel.studentLocations.removeAll()
        OnTheMapClient.logoutFromSession {
            // Remove all elements from the location model
            StudentLocationModel.studentLocations.removeAll()
            // Dismiss view
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
