//
//  MapViewController.swift
//  On The Map
//
//  Created by Vinoth kumar on 26/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        let span = MKCoordinateSpanMake(100.0, 100.0)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.833333, longitude: -98.583333), span: span)
        mapView.setRegion(region, animated: true)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StudentLocationMKAnnotation else { return nil }
        
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
    
    private class StudentAnnotationTapGestureRecognizer: UITapGestureRecognizer {
        var url: URL?
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let subtile = view.annotation?.subtitle {
            let url = URL(string: subtile!)
            let tapGesture = StudentAnnotationTapGestureRecognizer(target: self, action: #selector(tapped))
            tapGesture.url = url
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc  private func tapped(gesture : StudentAnnotationTapGestureRecognizer) {
        UIApplication.shared.open(gesture.url!, options: [:], completionHandler: nil)
    }
    
    public func reloadData() {
        loadData()
    }
    
    private func loadData () {
        
        var studentAnnotations: [StudentLocationMKAnnotation] = []
        mapView.removeAnnotations(mapView.annotations)
        ParseClient.sharedInstance().getLocations { (studentList, error) in

            if error != nil {
                self.displayError(error!.localizedDescription)
            } else {
            
            for student in studentList! {
                let studentLocation = StudentLocationMKAnnotation(coordinate: CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude) , title: student.fullname, subtitle: student.mediaURL)
                    studentAnnotations.append(studentLocation)
            }
            StudentsInformation.sharedInstance().studentList = studentList!
            performUIUpdates {
                self.mapView.addAnnotations(studentAnnotations)
            }
        }
        }
    }

}
