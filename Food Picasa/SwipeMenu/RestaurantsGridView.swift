//
//  RestaurantsGridView.swift
//  Food Picasa
//
//  Created by ER Minkush Takkar on 15/12/15.
//  Copyright (c) 2015 Origa Corporation. All rights reserved.
//


import UIKit
import Alamofire


class RestaurantsGridView:UIViewController,UICollectionViewDataSource ,UICollectionViewDelegate{
    
    @IBOutlet var menuButton:UIBarButtonItem!
    
    var identifier = "CellIdentifier"
    var headerViewIdentifier = "HeaderView"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var array_rest_id = [String]()
    var array_rest_name = [String]()
    var array_rest_logo = [String]()
    var array_rest_address = [String]()
    var array_rest_lat = [String]()
    var array_rest_lng = [String]()
    var array_rest_phone = [String]()
    var array_rest_email = [String]()
    
    
   // let dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                   
                  self.collectionView.reloadData()
                  ProgressHUD.hide()
                } catch {
                    print(error)
                }
        }
        
    }
   
    
    // MARK:- Selected Cell IndexPath
    func getIndexPathForSelectedCell() -> NSIndexPath? {
        
        var indexPath:NSIndexPath?
        
        if collectionView.indexPathsForSelectedItems()!.count > 0 {
            indexPath = collectionView.indexPathsForSelectedItems()![0] as NSIndexPath
        }
        return indexPath
    }
    
    

    // MARK:- prepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // retrieve selected cell & fruit
        
        if let indexPath = getIndexPathForSelectedCell() {
            
         //   let fruit = dataSource.fruitsInGroup(indexPath.section)[indexPath.row]
            
//            let detailViewController = segue.destinationViewController as! DetailViewController
//            detailViewController.fruit = fruit
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_rest_id.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier,forIndexPath:indexPath) as! CollectionViewCell
        
        if let checkedUrl = NSURL(string: GlobalAPI.api_get_url + "/" + array_rest_logo[indexPath.row]) {
            cell.imageView.contentMode = .ScaleAspectFit
            downloadImage(checkedUrl,image: cell.imageView)
        }
        
        cell.caption.text = array_rest_name[indexPath.row].capitalizedString
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView: CollectionViewCell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerViewIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        
        return headerView
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("maptorestaurantcategory", sender: self)
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath){
        
    }
    
    func downloadImage(url: NSURL,var image:UIImageView){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                image.image = UIImage(data: data)!
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
}


