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
        _ = OnTheMapClient.getRecentStudentLocations(completion: { (studentLocations, error) in
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
