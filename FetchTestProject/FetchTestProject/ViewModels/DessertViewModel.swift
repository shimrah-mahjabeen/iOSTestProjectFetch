//
//  DessertViewModel.swift
//  FetchTestProject
//
//  Created by Dev on 22/02/2024.
//

import UIKit

class DessertViewModel {
    
    var dessertData = Meal(meals: [])
    
    let cacheManager = CacheManager()
    
    func getCollectionViewCell(withCollectionView collectionView: UICollectionView, withIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CELLREUSEIDENTIFIERS.collectionViewCell, for: indexPath as IndexPath) as! DessertCollectionViewCell
        
        cell.DessertName.text = self.dessertData.meals[indexPath.row].dessertName
        let url = URL(string: self.dessertData.meals[indexPath.row].dessertImg)
        cacheManager.downloadImage(from: url!) { image in
            if let image = image {
                    DispatchQueue.main.async {
                        cell.DessertImage.image = image
                    }
                } else {
                    print("Failed to download image")
                }
        }
        return cell
    }
}


