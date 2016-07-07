//
//  ViewController.swift
//  MapKitTutorial
//
//  Created by Robert Chen on 12/23/15.
//  Copyright © 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import MapKit
import Social
import MessageUI

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController : UIViewController {
    
    
    @IBOutlet var shareOutlet: UIBarButtonItem!
    var selectedPin:MKPlacemark? = nil
    
    var resultSearchController:UISearchController? = nil
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        //
        //        var temp: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -33.952850, longitude: 151.138301)
        //
        //        let annotation = MyAnnotation(coordinate: temp)
        //
        //        annotation.title = "test"
        //
        //
        //
        //        mapView.addAnnotation(annotation)
        //
        
    }
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
        
        //
        //        let latitude = -33.952850
        //        let longitude = 151.138301
        //         let  location = CLLocation(latitude: latitude, longitude: longitude)
        //
        //
        //        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
        //
        //            if placemark?.count > 0
        //            {
        //                let pinForAppleMaps = placemark![0] as CLPlacemark
        //
        //                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: pinForAppleMaps.location!.coordinate, addressDictionary: pinForAppleMaps.addressDictionary as! [String:AnyObject]?))
        //
        //                let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        //                mapItem.openInMapsWithLaunchOptions(launchOptions)
        //
        //
        //
        //            }
        //        }
        
        
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        
        locationManager.stopUpdatingLocation()
        CLGeocoder().reverseGeocodeLocation(self.locationManager.location!) { (placemarks, error) in
            if error != nil
            {
                print("error" + (error?.localizedDescription)!)
            }
            
            if placemarks?.count > 0
            {
                let p = placemarks![0] as CLPlacemark
                
                
                let shareActionSheet = UIAlertController(title: nil, message: "Share with", preferredStyle: .ActionSheet)
                let twitterShareAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: { (action) in
                    
                    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
                    {
                        let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                        tweetComposer.setInitialText("Hey, It is my Location \n \(p.location?.coordinate.latitude) \(p.location?.coordinate.longitude)")
                        //
                        //tweetComposer.addImage(UIImage(data: subNote.image!))
                        self.presentViewController(tweetComposer, animated: true, completion: nil)
                    }
                    else
                    {
                        self.alert(extendMessage: "Twitter Unavailable", extendTitle: "Please log in to Twitter Account")
                    }
                    
                })
                let FacebookShareAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default, handler: { (action) in
                    
                    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
                    {
                        let FacebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                        FacebookComposer.setInitialText("Hey, It is my Location \n \(p.location!.coordinate.latitude) \n \(p.location!.coordinate.longitude)")
                        // FacebookComposer.addImage(UIImage(data: subNote.image!))
                        self.presentViewController(FacebookComposer, animated: true, completion: nil)
                    }
                    else
                    {
                        self.alert(extendMessage: "Facebook Unavailable", extendTitle: "Please log in to Facebook Account")
                    }
                    
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                shareActionSheet.addAction(twitterShareAction)
                shareActionSheet.addAction(FacebookShareAction)
                shareActionSheet.addAction(cancel)
                
                // This must have for ipad stimulator
                shareActionSheet.popoverPresentationController?.sourceView = self.view
                
                self.presentViewController(shareActionSheet, animated: true, completion: nil)
            }
            
        }
        
    }
    // Alert function
    func alert(extendMessage dataMessage: String, extendTitle dataTitle: String){
        
        let alertController = UIAlertController(title: dataMessage, message: dataTitle, preferredStyle: .Alert)
        let Cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(Cancel)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    //
    //    func displayLocationinfo(placeMark : CLPlacemark)
    //    {
    //        self.locationManager.stopUpdatingLocation()
    //        print(placeMark.administrativeArea!)
    //        print(placeMark.postalCode!)
    //        print(placeMark.country!)
    //        print(placeMark.location?.coordinate.latitude)
    //        print(placeMark.location?.coordinate.longitude)
    //        print(placeMark.locality!)
    //    }
    
}
extension ViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let UserLocation = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: UserLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        //            //let UserLocation = locations[0]
        //
        //            let latitude: CLLocationDegrees = UserLocation.coordinate.latitude
        //            let longtitude: CLLocationDegrees = UserLocation.coordinate.longitude
        //            let ladelta: CLLocationDegrees = 1
        //            let lodelta: CLLocationDegrees = 1
        //
        //            // these 2 must be implemented
        //            let span: MKCoordinateSpan = MKCoordinateSpanMake(ladelta, lodelta)
        //            let coordi : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
        //
        //            let region: MKCoordinateRegion = MKCoordinateRegionMake(coordi, span)
        //
        //            mapView.setRegion(region, animated: true)
        //
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        alert(extendMessage: "Erro", extendTitle: "Can't load location")
    }
}


extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea,
            let addressNumber = placemark.subThoroughfare,
            let street = placemark.thoroughfare
        {
            annotation.subtitle = "\(addressNumber) \(street), \(city), \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orangeColor()
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        button.addTarget(self, action: #selector(ViewController.getDirections), forControlEvents: .TouchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}