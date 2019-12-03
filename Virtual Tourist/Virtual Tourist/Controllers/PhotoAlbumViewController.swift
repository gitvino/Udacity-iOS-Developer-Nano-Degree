//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Vinoth kumar on 3/5/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var collectionViewFlowlayout: UICollectionViewFlowLayout!
    var pin: Pin?
    var photosUrlDataSource: [String]?
    
    let networkingInstance = NetworkingManager.sharedInstance
    let databaseInstance = DatabaseManager.sharedInstance
    
    var isPinImagesEmpty: Bool {
        if pin!.images?.count != 0  {
            return false
        } else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
        collectionView.allowsMultipleSelection = true

        let latitude = (pin!.latitude! as NSString).doubleValue
        let longitude = (pin!.longitude! as NSString).doubleValue
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let annotation = VTAnnotation(coordinate:coordinate , pinID: pin!.objectID)
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = coordinate
        
        if let _ = pin {
            if isPinImagesEmpty {
                //retrive from internet and save
                photosUrlDataSource = []
                downloadAndUpdateUI()
            } else {
                //load from database
                photosUrlDataSource = databaseInstance.fectchImageURLs(pin: pin!)
            }
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        let space: CGFloat = 1.0
        let width = (self.view.frame.width - 20)/3
        collectionViewFlowlayout.itemSize = CGSize(width: width, height: width)
        collectionViewFlowlayout.minimumInteritemSpacing = space
        
        collectionViewFlowlayout.minimumLineSpacing = space
    }
    
    
    func downloadAndUpdateUI() -> Void {
        networkingInstance.getPhotoURLsByLocation(
            latitude: pin!.latitude!,
            longitude: pin!.longitude!,
            successHandler: { (photoUrlsArray) in
                self.photosUrlDataSource = photoUrlsArray
              
                performUIUpdatesOnMain {
                    self.collectionView.reloadData()
                }
                
                for (index, photoUrlString) in photoUrlsArray.enumerated() {
                    //For each Image URL:  Download, Save, Update UI
                    //1. Download
                    self.downloadImage(index: index, urlString: photoUrlString)
                }
        }) { (errorMessage) in
            print(errorMessage)
        }
        
        
    }
    func downloadImage(index: Int, urlString: String) -> Void {
        //
        networkingInstance.downloadImage(
            
            photoURL: urlString,
            successCompletionHandler: { (imageData) in
                //2. Save Image to Database
                self.databaseInstance.saveImage(pin: self.pin!, photoUrl: urlString, imageData: imageData)
                
                //3. Update Collection View Cell
                performUIUpdatesOnMain {
                    self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            
        }) { (errorMessage) in
            print(errorMessage)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return photosUrlDataSource!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell

        if let imageData = databaseInstance.retrieveImageFromURL(urlString: photosUrlDataSource![indexPath.row]) {
            cell.imageView.image = UIImage(data: imageData)
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "loading")
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = CGFloat(.pi * 2.0)
            rotateAnimation.duration = 1.5
            rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
    
            cell.imageView.layer.add(rotateAnimation, forKey: nil)
            
        }
        cell.isSelected = false
        return cell
    }

    
   
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       toggleNewCollectionBarButton()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        toggleNewCollectionBarButton()
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func toggleNewCollectionBarButton() -> Void {
        if collectionView.indexPathsForSelectedItems!.isEmpty {
            newCollectionButtonItem.title = "New Collection"
        } else {
            newCollectionButtonItem.title = "Delete"
        }
    }
    

    @IBAction func newCollectionBarButtonPressed(_ sender: Any) {
        switch newCollectionButtonItem.title {
        case "New Collection":
            databaseInstance.deleteAllPhotos(pin: pin!)
           downloadAndUpdateUI()
        case "Delete":

            for indexPath in collectionView.indexPathsForSelectedItems!.enumerated() {
                databaseInstance.deletePhotosFromDB(urlString: photosUrlDataSource![indexPath.element[1]])
            }
            photosUrlDataSource = databaseInstance.fectchImageURLs(pin: pin!)
            collectionView.reloadData()
            toggleNewCollectionBarButton()
        default:
            break
        }
    }
    
   
}
