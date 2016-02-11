//
//  RestaurantsGridView.swift
//  Food Picasa
//
//  Created by ER Minkush Takkar on 15/12/15.
//  Copyright (c) 2015 Origa Corporation. All rights reserved.
//

import Foundation
import UIKit

class SwipeContainerView:UIViewController {
    
    @IBOutlet var menuButton:UIBarButtonItem!
    
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
//
        // MARK: - UI Setup
        
        self.title = "Food Picasa"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 128.0/255.0, green: 70.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        var menuiconArray : [String] = []
        var unselectedmenuiconArray : [String] = []
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller1 = storyboard.instantiateViewControllerWithIdentifier("RestaurantsMapView") 
        
       // var controller1 : RestaurantsMapView = RestaurantsMapView(nibName: "RestaurantsMapView", bundle: nil)
//        let controller1 = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantsMapView") as! RestaurantMenuItems
        controller1.title = "Map View"
        
        menuiconArray.append("selectedswipemap");
        unselectedmenuiconArray.append("unselectedswipemap");
        
        controllerArray.append(controller1)
        
        let controller2 = storyboard.instantiateViewControllerWithIdentifier("RestaurantsGridView") 
     //   var controller2 : RestaurantsGridView = RestaurantsGridView(nibName: "RestaurantsGridView", bundle: nil)
     //   let controller2 = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantsGridView") as! RestaurantMenuItems
        controller2.title = "Table View"
        controllerArray.append(controller2)
        menuiconArray.append("selectedlistview");
        unselectedmenuiconArray.append("unselectedlistview");
        
      
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 249.0/255.0, green: 245.0/255.0, blue: 249.0/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)),
            .BottomMenuHairlineColor(UIColor(red: 128.0/255.0, green: 70.0/255.0, blue: 173.0/255.0, alpha: 1.0)),
            .MenuMargin(20.0),
            .MenuHeight(40.0),
            .SelectedMenuItemLabelColor(UIColor(red: 128.0/255.0, green: 70.0/255.0, blue: 173.0/255.0, alpha: 1.0)),
            .UnselectedMenuItemLabelColor(UIColor.grayColor()),
            .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorRoundEdges(true),
            .SelectionIndicatorHeight(2.0),
            .MenuItemSeparatorPercentageHeight(0.1)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters , imageicon: menuiconArray,unselectedimageicon: unselectedmenuiconArray)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMoveToParentViewController(self)
    }
    
    func didTapGoToLeft() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    func didTapGoToRight() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }
    
    // MARK: - Container View Controller
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    
}

