//
//  InformationPostingMapViewController.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 04/04/2021.
//

import UIKit
import MapKit

class InformationPostingMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // The location search query value
    var locationNaturalLanguageQuery: String!
    // The set media URL
    var mediaURL: String!
    // Represents the found MapItem from the MKLocalSearch
    private var foundLocationMapItem: MKMapItem = MKMapItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Search the location and populate the matching items
        searchLocation()
    }
    
    // MARK: Search the location using MKLocalSearch
    
    func searchLocation() {
        let locationRequest = MKLocalSearch.Request()
        locationRequest.naturalLanguageQuery = locationNaturalLanguageQuery
        locationRequest.region = mapView.region
        
        let locationSearch = MKLocalSearch(request: locationRequest)
        self.showActivity()
        locationSearch.start { (response, error) in
            guard let response = response else {
                self.showStatus(title: "Location search failure", message: "The location could not be found. Please check your search query.")
                return
            }
            self.foundLocationMapItem = response.mapItems[0]
            // Drop pin on map for the first found item
            self.dropPin()
            self.removeActivity()
        }
    }
    
    // MARK: Creates an annotation from the found MKMapItem and focuses the map on the found region
    
    func dropPin() {
        let foundLocationPlacemark = foundLocationMapItem.placemark
        let locationAnnotation = MKPointAnnotation()
        locationAnnotation.coordinate = foundLocationPlacemark.coordinate
        locationAnnotation.title = foundLocationMapItem.name
        mapView.addAnnotation(locationAnnotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: foundLocationPlacemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        if let lastStudentLocationInformation = StudentLocationModel.lastLocationInformation {
            // Found a previous student location, we update the location
            updateStudentLocation(lastStudentLocationInformation: lastStudentLocationInformation)
        } else {
            // Get basic student information
            OnTheMapClient.getStudentInformation { (studentInformationDictionary, error) in
                self.addStudentLocation(studentInformationDictionary: studentInformationDictionary)
            }
        }
    }
    
    func addStudentLocation(studentInformationDictionary: [String:Any]) {
        // Get user info
        let firstName = studentInformationDictionary["first_name"] as! String
        let lastName = studentInformationDictionary["last_name"] as! String
        // Student location info
        let latitude = foundLocationMapItem.placemark.coordinate.latitude
        let longitude = foundLocationMapItem.placemark.coordinate.longitude
        // Link info
        let mapString = locationNaturalLanguageQuery!
        
        // Post the student information
        OnTheMapClient.postNewStudentLocation(firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude) { (success, error) in
            if success {
                self.showStatus(title: "Added location successfully", message: "The location was successfully posted to the server.")
            } else {
                self.showStatus(title: "Add location failed", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func updateStudentLocation(lastStudentLocationInformation: StudentInformation) {
        OnTheMapClient.updateStudentLocation(firstName: lastStudentLocationInformation.firstName, lastName: lastStudentLocationInformation.lastName, mapString: locationNaturalLanguageQuery!, mediaURL: mediaURL, latitude: foundLocationMapItem.placemark.coordinate.latitude, longitude: foundLocationMapItem.placemark.coordinate.longitude) { (success, error) in
            if success {
                self.showStatus(title: "Location updated successfully", message: "The location was successfully updated to the server.")
            } else {
                self.showStatus(title: "Add location failed", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func showStatus(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            // Return control back to the Add location page
            DispatchQueue.main.async {
                //self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
}
