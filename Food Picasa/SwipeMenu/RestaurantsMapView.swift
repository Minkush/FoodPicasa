//
//  RestaurantsMapView.swift
//  Food Picasa
//
//  Created by ER Minkush Takkar on 17/12/15.
//  Copyright (c) 2015 Origa Corporation. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantsMapView:UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,NSURLConnectionDelegate {
    
  
    @IBOutlet weak var viewMap: GMSMapView!
    
    var locationManager = CLLocationManager()
    var locationMarker: GMSMarker!
    
    var didFindMyLocation = false
    
    var array_rest_id = [String]()
    var array_rest_name = [String]()
    var array_rest_logo = [String]()
    var array_rest_address = [String]()
    var array_rest_lat = [String]()
    var array_rest_lng = [String]()
    var array_rest_phone = [String]()
    var array_rest_email = [String]()
    
  lazy var data = NSMutableData()
    
    
    override func viewDidLoad() {
     
        locationManager.delegate = self
        viewMap.delegate = self
        
        
        locationManager.requestWhenInUseAuthorization()
        
        viewMap.myLocationEnabled = true
        
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
        array_rest_id.removeAll()
        array_rest_name.removeAll()
        array_rest_logo.removeAll()
        array_rest_address.removeAll()
        array_rest_lat.removeAll()
        array_rest_lng.removeAll()
        array_rest_phone.removeAll()
        array_rest_email.removeAll()
        
        ProgressHUD.show(true)
        Alamofire.request(.GET, GlobalAPI.api_get_restaurents, parameters: nil)
            .responseJSON { response in
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions())
                    if let rests = json as? [[String: AnyObject]] {
                        for rests in rests {
                            
                            let rest_id = rests["restaurants_id"]
                            let rest_name = rests["restaurants_name"]
                            let rest_logo = rests["restaurants_logo"]
                            let rest_address = rests["restaurants_address"]
                            let rest_lat = rests["restaurants_lat"]
                            let rest_lng = rests["restaurants_lng"]
                            let rest_phone = rests["restaurants_phone"]
                            let rest_email = rests["restaurants_email"]
                            
                            self.array_rest_id.append(rest_id as! String!)
                            self.array_rest_name.append(rest_name as! String!)
                            self.array_rest_logo.append(rest_logo as! String!)
                            self.array_rest_address.append(rest_address as! String!)
                            self.array_rest_lat.append(rest_lat as! String!)
                            self.array_rest_lng.append(rest_lng as! String!)
                            self.array_rest_phone.append(rest_phone as! String!)
                            self.array_rest_email.append(rest_email as! String!)
                        }
                    }
                    print(self.array_rest_name)
                    self.setupLocationMarker()
                    ProgressHUD.hide()
                } catch {
                    print(error)
                }
        }
        
    }
    
    
    
     func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        
          self.performSegueWithIdentifier("maptorestaurantcategory", sender: self)
        
    }
    
    func setupLocationMarker() {
        if locationMarker != nil {
            locationMarker.map = nil
        }
        
        for var i = 0; i < array_rest_id.count; i++
        {
        
        let latitude:CLLocationDegrees = Double(array_rest_lat[i])!
        let longitude:CLLocationDegrees = Double(array_rest_lng[i])!
            
        let position: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
        locationMarker = GMSMarker(position: position)
        locationMarker.map = viewMap
        
        locationMarker.title = array_rest_name[i]
        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        locationMarker.opacity = 0.75
        
        locationMarker.flat = true
      //  locationMarker.snippet = "The best place on earth."
            
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
            didFindMyLocation = true
            
         //   let coordinate = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            self.viewMap.settings.myLocationButton = true
            
            
        }
    }


}
