//
//  ListViewController.swift
//  On The Map
//
//  Created by Vinoth kumar on 29/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let uiNib = UINib(nibName: "StudentCellTableViewCell", bundle: nil)
        tableView.register(uiNib, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentCellTableViewCell
        let student = StudentsInformation.sharedInstance().studentList[indexPath.row]
        cell.fullName.text = student.fullname
        cell.mediaURL.text = student.mediaURL
        return cell
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsInformation.sharedInstance().studentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentsInformation.sharedInstance().studentList[indexPath.row]
        let url = URL(string: student.mediaURL)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func reloadData(){
        loadData()
    }
    
    private func loadData () {
    
        ParseClient.sharedInstance().getLocations { (studentList, error) in
   
            if error != nil {
                self.displayError(error!.localizedDescription)
            } else {
                StudentsInformation.sharedInstance().studentList = studentList!
            performUIUpdates {
                self.tableView.reloadData()
            }
            }
        }
        
    }
 
}
