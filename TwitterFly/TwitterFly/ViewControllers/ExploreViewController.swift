//
//  ExploreViewController.swift
//  TwitterFly
//
//  Created by Vinoth on 26/7/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import UIKit
import CoreLocation

class ExploreViewController: BaseViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var userLocation: CLLocation?
    var trendDataSource: [Trend] = []
    var locationDatasource: String?
    
    @IBOutlet weak var trendTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. setup TableView
        setupTableView()
        guard let _ = locationDatasource else {
            self.title = "Trends"
            return
        }
        self.title = locationDatasource
    }
    func setupTableView() -> Void {
        trendTableView.dataSource = self
        trendTableView.delegate = self
        trendTableView.register(UINib(nibName: "TrendCell", bundle: nil), forCellReuseIdentifier: "TrendCell")
        trendTableView.rowHeight = 70
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLocation()
        if userLocation != nil  {
            
            let userLocation2D = userLocation!.coordinate
            ExploreManager.shared.getTrendsLocation(locationCoordinate: userLocation2D, successHandler: { (woeid, locationName) -> Void in
                
                guard let woeid = woeid else {
                    return
                }
                guard let name = locationName else {
                    return
                }
                self.locationDatasource = name
                ExploreManager.shared.getTrendsByLocation(woeid: woeid, sucessHandler: { trends in
                    self.trendDataSource = trends
                    DispatchQueue.main.async {
                        self.trendTableView.reloadData()
                        self.title = "\(self.locationDatasource!) Trends"
                    }
                    
                }, failureHandler: { error in
                    self.displayError(error: error!)
                })
                
            }) { (error) in
                self.displayError(error: error!)
                
            }
        }
        
    }

    func getLocation(){
        locationManager = CLLocationManager()
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            
        case .notDetermined:
            locationManager!.requestWhenInUseAuthorization()
            trendTableView.reloadData()
            
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services", message: "Please enable Location Services", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil )
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        case .authorizedWhenInUse:
            userLocation = locationManager?.location
            locationManager!.delegate = self
            locationManager!.startUpdatingLocation()
            
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation  = locations[0]
        print(locations)
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (trendDataSource.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendCell", for: indexPath) as! TrendCell
        cell.countCell.text = "\(indexPath.row + 1)"
        cell.trendTopic.text = trendDataSource[indexPath.row].name
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(trendDataSource[indexPath.row].name)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

