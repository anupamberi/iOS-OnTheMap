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
    
    var locationNaturalLanguageQuery: String!
    var mediaURL: String!

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
        locationSearch.start { (response, error) in
            guard let response = response else {
                self.showFailure(message: "The location could not be found")
                return
            }
            self.foundLocationMapItem = response.mapItems[0]
            // Drop pin on map for the first found item
            self.dropPin()
        }
    }
    
    // MARK: Creates an annotation from the found MKMapItem and focuses the map on the found region
    
    func dropPin() {
        let foundLocationPlacemark = foundLocationMapItem.placemark
        let locationAnnotation = MKPointAnnotation()
        locationAnnotation.coordinate = foundLocationPlacemark.coordinate
        locationAnnotation.title = foundLocationMapItem.name
        mapView.addAnnotation(locationAnnotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: foundLocationPlacemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        // Get basic student information
        OnTheMapClient.getStudentInformation { (studentInformationDictionary, error) in
            print("On completion")
            
        }
    }
    
    func postStudentLocation(studentInformationDictionary: [String:Any]) {
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
                
            } else {
                self.showFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Add location failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
