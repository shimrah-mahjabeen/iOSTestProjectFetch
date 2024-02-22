//
//  CacheManager.swift
//  FetchTestProject
//
//  Created by Dev on 22/02/2024.
//

import UIKit

class CacheManager {
    
    private let urlCache = URLCache.shared
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check if the image is already cached
        if let cachedResponse = urlCache.cachedResponse(for: URLRequest(url: url)) {
            // If cached, return the image from cache
            if let image = UIImage(data: cachedResponse.data) {
                completion(image)
                return
            }
        }
        
        // If not cached, download the image
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            // Cache the downloaded image
            let cachedData = CachedURLResponse(response: response!, data: data)
            self.urlCache.storeCachedResponse(cachedData, for: URLRequest(url: url))
            
            // Return the downloaded image
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
