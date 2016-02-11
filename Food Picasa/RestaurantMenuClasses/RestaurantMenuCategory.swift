//
//  RestaurantMenuCategory.swift
//  Food Picasa
//
//  Created by Apple on 07/02/16.
//  Copyright © 2016 Origa Corporation. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class RestaurantMenuCategory:UIViewController,UICollectionViewDataSource ,UICollectionViewDelegate {
    
    
    var identifier = "CellIdentifier"
    var headerViewIdentifier = "HeaderView"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var array_rest_cat_id = [String]()
    var array_rest_cat_name = [String]()
    var array_rest_cat_logo = [String]()
    
    
    override func viewDidAppear(animated: Bool) {
        
        
        array_rest_cat_id.removeAll()
        array_rest_cat_name.removeAll()
        array_rest_cat_logo.removeAll()
      
        let parm = ["r_id":73]
        
        ProgressHUD.show(true)
        Alamofire.request(.GET, GlobalAPI.api_get_restaurent_category, parameters: parm)
            .responseJSON { response in
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions())
                    if let rests = json as? [[String: AnyObject]] {
                        for rests in rests {
                            
                            let rest_menu_cat_id = rests["restaurants_menu_category_id"]
                            let rest_menu_cat_name = rests["restaurants_menu_category_name"]
                            let rest_menu_cat_logo = rests["restaurants_menu_category_logo"]
                           
                            
                            self.array_rest_cat_id.append(rest_menu_cat_id as! String!)
                            self.array_rest_cat_name.append(rest_menu_cat_name as! String!)
                            self.array_rest_cat_logo.append(rest_menu_cat_logo as! String!)
                            
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
        return array_rest_cat_id.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier,forIndexPath:indexPath) as! CollectionViewCell
        
        if let checkedUrl = NSURL(string: GlobalAPI.api_get_url + "/" + array_rest_cat_logo[indexPath.row]) {
            cell.imageView.contentMode = .ScaleAspectFit
            downloadImage(checkedUrl,image: cell.imageView)
        }
        
        cell.caption.text = array_rest_cat_name[indexPath.row].capitalizedString
        
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
