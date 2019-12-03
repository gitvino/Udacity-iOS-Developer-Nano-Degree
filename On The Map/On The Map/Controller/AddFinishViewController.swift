//
//  AddFinishViewController.swift
//  On The Map
//
//  Created by Vinoth kumar on 30/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddFinishViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var finishButtonConstraint: NSLayoutConstraint!
    var placemark: CLPlacemark?
    var mapString: String?
    var mediaURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        mapView.delegate = self
        
        let span = MKCoordinateSpanMake(10.0, 10.0)
        let region = MKCoordinateRegion(center: (placemark?.location?.coordinate)!, span: span)
        mapView.setRegion(region, animated: true)
        
        let myLocation = MyLocation(coordinate: (placemark?.location?.coordinate)!, title: (placemark?.name)!, subtitle: (placemark?.country)!)
        mapView.addAnnotation(myLocation)
        finishButtonConstraint.constant = (view.frame.height) / 5
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? MyLocation else { return nil }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            
            view = dequeuedView
            
        } else {
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.text = annotation.subtitle
            view.detailCalloutAccessoryView = label

        }
        return view
    }
    
    @IBAction func finishPressed(_ sender: Any) {
       let udacityUser = appDelegate.udacityUser!
        
        UdacityClient.sharedInstance().getUserProfile(sessionID: udacityUser.sessionId!, userID: udacityUser.userId!) { (result, error) in 
            
            guard error == nil else {
                self.displayError(error!.localizedDescription)
                return
            }
            
            let udacityUser = result as! UdacityClient
            
            ParseClient.sharedInstance().postLocation(uniqueKey: udacityUser.userId!,
                                                      firstName: udacityUser.firstName!,
                                                      lastName: udacityUser.lastName!,
                                                      mapString: self.mapString!,
                                                      mediaURL: self.mediaURL!,
                                                      location: (self.placemark?.location?.coordinate)!)
             { result, error in

                guard error == nil else {
                    self.displayError("Submit failed. Please try again")
                    return
                }
                if let objectId = result!["objectId"] { 
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
