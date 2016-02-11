//
//  RestaurantMenuItems.swift
//  Food Picasa
//
//  Created by ER Minkush Takkar on 20/12/15.
//  Copyright (c) 2015 Origa Corporation. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class RestaurantMenuItems:UIViewController,UICollectionViewDataSource ,UICollectionViewDelegate {
    
//    [{"restaurants_menu_id":"1","restaurants_menu_typeofdish":"Vegan","restaurants_name":"Temporary","restaurants_id":"73","restaurants_menu_logo_name":"Temporary_name1_minku.jpg","restaurants_menu_logo":"admin\/phpfiles\/photos\/menus\/Temporary_name1_minku.jpg","restaurants_category":"cat_temp1","restaurants_nameofdish":"name1","restaurants_price":"cost1","restaurants_detail":"detail"},{"restaurants_menu_id":"2","restaurants_menu_typeofdish":"Vegan","restaurants_name":"Temporary","restaurants_id":"73","restaurants_menu_logo_name":"Temporary_name2_minku.jpg","restaurants_menu_logo":"admin\/phpfiles\/photos\/menus\/Temporary_name2_minku.jpg","restaurants_category":"cat_temp1","restaurants_nameofdish":"name2","restaurants_price":"cost2","restaurants_detail":"detail2"}]

    var identifier = "CellIdentifier"
    var headerViewIdentifier = "HeaderView"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var array_rest_menu_id = [String]()
    var array_rest_menu_typeofdish = [String]()
    var array_rest_menu_logo = [String]()
    var array_rest_menu_nameofdish = [String]()
    var array_rest_menu_price = [String]()
    var array_rest_menu_dish_detail = [String]()
    
    override func viewDidLoad() {
        
        array_rest_menu_id.removeAll()
        array_rest_menu_typeofdish.removeAll()
        array_rest_menu_logo.removeAll()
        array_rest_menu_nameofdish.removeAll()
        array_rest_menu_price.removeAll()
        array_rest_menu_dish_detail.removeAll()
        
        let parm = ["r_id":73]
        
        ProgressHUD.show(true)
        Alamofire.request(.GET, GlobalAPI.api_get_restaurent_menuitems, parameters: parm)
            .responseJSON { response in
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions())
                    if let rests = json as? [[String: AnyObject]] {
                        for rests in rests {
                            
                            let rest_menu_id = rests["restaurants_menu_id"]
                            let rest_menu_typeofdish = rests["restaurants_menu_typeofdish"]
                            let rest_menu_logo = rests["restaurants_menu_logo"]
                            
                            let rest_menu_nameofdish = rests["restaurants_nameofdish"]
                            let rest_menu_dish_price = rests["restaurants_price"]
                            let rest_menu_dish_detail = rests["restaurants_detail"]
                            
                            
                            self.array_rest_menu_id.append(rest_menu_id as! String!)
                            self.array_rest_menu_typeofdish.append(rest_menu_typeofdish as! String!)
                            self.array_rest_menu_logo.append(rest_menu_logo as! String!)
                            self.array_rest_menu_nameofdish.append(rest_menu_nameofdish as! String!)
                            self.array_rest_menu_price.append(rest_menu_dish_price as! String!)
                            self.array_rest_menu_dish_detail.append(rest_menu_dish_detail as! String!)
                            
                        }
                    }
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
        return array_rest_menu_id.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier,forIndexPath:indexPath) as! CollectionViewCell
        
        if let checkedUrl = NSURL(string: GlobalAPI.api_get_url + "/" + array_rest_menu_logo[indexPath.row]) {
            cell.imageView.contentMode = .ScaleAspectFit
            downloadImage(checkedUrl,image: cell.imageView)
        }
        
        cell.caption.text = array_rest_menu_nameofdish[indexPath.row].capitalizedString
        
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
