//
//  TravelLocationsViewController.swift
//  Virtual Tourist
//
//  Created by Vinoth kumar on 2/5/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class TravelLocationsViewController: UIViewController {

    @IBOutlet weak var travelMap: MKMapView!
    var dataController: DataController?
    var pins: [Pin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        travelMap.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(mapPressed))
        travelMap.addGestureRecognizer(longPressGesture)

        reloadPins()
        // Do any additional setup after loading the view.
    }
    
    
    @objc func mapPressed(gestureRecognizer: UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = gestureRecognizer.location(in: travelMap)
            let newCoordinates = travelMap.convert(touchPoint, toCoordinateFrom: travelMap)
            //Create Pin
            let pinID = createPin(location: newCoordinates)
            let annotation = VTAnnotation(coordinate: newCoordinates, pinID: pinID)
            travelMap.addAnnotations([annotation])
            
            // reload Pins
            reloadPins()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createPin(location: CLLocationCoordinate2D) -> NSManagedObjectID {
        let pin = Pin(context: dataController!.viewContext)
        pin.latitude = "\(location.latitude)"
        pin.longitude = "\(location.longitude)"
        
        try? dataController!.viewContext.save()
        return pin.objectID
    }
 
    
    func getPinsFromDB() -> [Pin] {
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController!.viewContext.fetch(fetchRequest) {
            pins = result
        }
       
        return pins
    }
 
    
    func reloadPins(){
        pins = getPinsFromDB()
        var annotations = [MKAnnotation]()
        travelMap.removeAnnotations(travelMap.annotations)
        
        for eachPin in pins {
           
            let latitude = (eachPin.latitude! as NSString).doubleValue
            let longitude = (eachPin.longitude! as NSString).doubleValue
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let annotation = VTAnnotation(coordinate:coordinate , pinID: eachPin.objectID)
            annotations.append(annotation)
            
        }
        travelMap.addAnnotations(annotations)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
    
extension TravelLocationsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        let selectedAnnotation = view.annotation as! VTAnnotation
        let selectedPinID = selectedAnnotation.pinID
        
        mapView.deselectAnnotation(view.annotation, animated: true)
        let photoAlbumVC  = storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
        photoAlbumVC.pin = dataController!.viewContext.object(with: selectedPinID) as? Pin
       
        navigationController?.pushViewController(photoAlbumVC, animated: true)
    }
    
}







