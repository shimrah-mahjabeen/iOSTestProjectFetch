//
//  Constants.swift
//  FetchTestProject
//
//  Created by Dev on 22/02/2024.
//

import Foundation

struct Constants{
    
    struct BASEURL{
        static let baseUrl = "https://themealdb.com/api"
    }
    
    struct ENDPOINTS{
        static let fetchDessert = "/json/v1/1/filter.php?c=Dessert"
        static let fetchDessertDetails = "/json/v1/1/lookup.php?i="
    }
    
    struct CELLREUSEIDENTIFIERS{
        static let collectionViewCell = "DessertCollectionViewCell"
        static let tableViewCell = "DessertDetailTableViewCell"
    }
}
