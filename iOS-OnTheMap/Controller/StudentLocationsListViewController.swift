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
        if StudentLocationModel.studentLocations.count == 0 {
            populateStudentLocations()
        }
    }
    
    @objc func refreshTapped(_ sender: UIBarButtonItem) {
        populateStudentLocations()
    }
    
    @objc func addLocationTapped(_ sender: UIBarButtonItem) {
        let informationPostingViewController = self.storyboard?.instantiateViewController(identifier: "InformationPostingViewController") as! InformationPostingViewController
        self.navigationController?.pushViewController(informationPostingViewController, animated: true)
    }
    
    func populateStudentLocations() {
        OnTheMapClient.getRecentStudentLocations(completion: { (studentLocations, error) in
            print("Got student locations")
            StudentLocationModel.studentLocations = studentLocations
            self.tableView.reloadData()
        })
    }
}

extension StudentLocationsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationModel.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell") as! StudentLocationsTableViewCell

        let studentLocation = StudentLocationModel.studentLocations[indexPath.row]
        
        cell.studentFullName.text = studentLocation.firstName + " " + studentLocation.lastName
        cell.iconImageView.image = UIImage(named: "icon_pin")
        cell.studentMediaURL.text = studentLocation.mediaURL

        return cell
    }
}
