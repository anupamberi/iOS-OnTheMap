//
//  StudentLocationsListView.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 03/04/2021.
//

import UIKit

class StudentLocationsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
            StudentLocationModel.recentStudentLocations = studentLocations
            self.tableView.reloadData()
            self.removeActivity()
        })
    }
}

extension StudentLocationsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationModel.recentStudentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell") as! StudentLocationsTableViewCell

        let studentLocationInformation = StudentLocationModel.recentStudentLocations[indexPath.row]
        
        cell.studentFullName.text = studentLocationInformation.firstName + " " + studentLocationInformation.lastName
        cell.iconImageView.image = UIImage(named: "icon_pin")
        cell.studentMediaURL.text = studentLocationInformation.mediaURL

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocationInformation = StudentLocationModel.recentStudentLocations[indexPath.row]

        guard let requestURL = URL(string: studentLocationInformation.mediaURL) else {
            return
        }
        // Open the URL
        UIApplication.shared.open(requestURL, options: [:], completionHandler: nil)
        
    }
}
