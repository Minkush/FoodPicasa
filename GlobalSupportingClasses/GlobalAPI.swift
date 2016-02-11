//
//  GlobalAPI.swift
//  Food Picasa
//
//  Created by Apple on 06/02/16.
//  Copyright © 2016 Origa Corporation. All rights reserved.
//

import Foundation

class GlobalAPI:NSObject {
    
    // key:value
    // id
    class var api_get_url: String { return "http://www.foodpicasa.com" }
    
    
    class var api_get_restaurent_category: String { return "http://foodpicasa.com/webservices/getrestaurentcategory.php" }
    
    class var api_get_restaurent_menuitems: String { return "http://foodpicasa.com/webservices/getrestaurentmenuitems.php" }
    
    class var api_get_restaurents: String { return "http://www.foodpicasa.com/webservices/getrestaurent.php" }
    
    
    
}