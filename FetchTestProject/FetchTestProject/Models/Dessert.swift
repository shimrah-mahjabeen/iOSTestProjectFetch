//
//  File.swift
//  FetchTestProject
//
//  Created by Dev on 22/02/2024.
//

import Foundation

// MARK: - Meal
struct Meal: Decodable {
    var meals: [Dessert]
}

// MARK: - Dessert
struct Dessert: Decodable {
    let dessertName: String
    let dessertImg: String
    let dessertID: String
    
    enum CodingKeys: String, CodingKey {
        case dessertName = "strMeal"
        case dessertImg = "strMealThumb"
        case dessertID = "idMeal"
    }
}

