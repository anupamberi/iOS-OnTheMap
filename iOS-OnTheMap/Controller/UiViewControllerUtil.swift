//
//  UiViewControllerExtension.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 03/04/2021.
//
import UIKit

fileprivate var activityView : UIView?

// MARK : Contains utility methods that are reused among UIViewControllers

extension UIViewController {
    
    func showActivity() {
        activityView = UIView(frame: self.view.bounds)
        activityView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicatorView.center = activityView!.center
        activityIndicatorView.startAnimating()
        activityView?.addSubview(activityIndicatorView)
        self.view.addSubview(activityView!)
    }
    
    func removeActivity() {
        activityView?.removeFromSuperview()
        activityView = nil
    }
    
    @objc func logoutTapped(_ sender: UIBarButtonItem) {
        OnTheMapClient.logoutFromSession {
            // Remove all elements from the location model
            StudentLocationModel.recentStudentLocations.removeAll()
            // Dismiss view
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func addLocationTapped(_ sender: UIBarButtonItem) {
        let informationPostingViewController = self.storyboard?.instantiateViewController(identifier: "InformationPostingViewController") as! InformationPostingViewController
        self.present(UINavigationController(rootViewController: informationPostingViewController), animated: true)
    }
    
    
}
