//
//  ImageLoader.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Return cached image if available
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }

        // Validate URL
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        // Fetch image from network
        session.dataTask(with: url) { [weak self] data, _, error in
            guard
                let self = self,
                let data = data,
                error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // Cache the image
            self.cache.setObject(image, forKey: urlString as NSString)

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
