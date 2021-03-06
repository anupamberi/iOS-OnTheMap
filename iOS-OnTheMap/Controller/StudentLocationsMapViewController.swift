//
//  StudentLocationsMapViewController.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 03/04/2021.
//

import UIKit
import MapKit

class StudentLocationsMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add left and right navigation item buttons
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutTapped(_:)))
        
        self.navigationItem.leftBarButtonItem = logoutButton
        
        let refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refreshTapped(_:)))
        
        let addLocationButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addLocationTapped(_:)))
        
        self.navigationItem.rightBarButtonItems = [refreshButton, addLocationButton]

        // Populate student locations if not already populated earlier
        if StudentLocationModel.recentStudentLocations.count == 0 {
            self.showActivity()
            populateStudentLocations()
        }
    }
    
    @objc func refreshTapped(_ sender: UIBarButtonItem) {
        self.showActivity()
        populateStudentLocations()
    }
    
    func populateStudentLocations() {
        OnTheMapClient.getRecentStudentLocations(completion: { (studentLocations, error) in
            if let error = error {
                print(error)
                self.showLocationsFetchFailure(message: "Could not fetch the student location information. Please try later.")
                self.removeActivity()
            } else {
                StudentLocationModel.recentStudentLocations = studentLocations
                // Remove previous annotations
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(self.getAnnotations())
                self.removeActivity()
            }
        })
    }
    
    func getAnnotations() -> [MKAnnotation] {
        var annotations = [MKAnnotation]()
        // Code adapted from pinSample example
        for studentLocation in StudentLocationModel.recentStudentLocations {
            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName
            let last = studentLocation.lastName
            let mediaURL = studentLocation.mediaURL
            
            // Create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Append to an array of annotations.
            annotations.append(annotation)
        }
        return annotations
    }
    
    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func showLocationsFetchFailure(message: String) {
        let alertVC = UIAlertController(title: "Locations fetch error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                //app.openURL(URL(string: toOpen)!)
            }
        }
    }
}
