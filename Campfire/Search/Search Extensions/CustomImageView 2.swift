//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 4/5/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

//var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
//    var lastURLUsedToLoadImage: String?
    
    
//    func loadImage(urlString: String) {
//        lastURLUsedToLoadImage = urlString
//
//        self.image = nil
//
//        if let cachedImage = imageCache[urlString] {
//            self.image = cachedImage
//            return
//        }
//
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, response, err) in
//            if let err = err {
//                print("Failed to fetch post image:", err)
//                return
//            }
//
//            if url.absoluteString != self.lastURLUsedToLoadImage {
//                return
//            }
//
//            guard let imageData = data else { return }
//
//            let photoImage = UIImage(data: imageData)
//
//            imageCache[url.absoluteString] = photoImage
//
//            DispatchQueue.main.async {
//                self.image = photoImage
//            }
//
//            }.resume()
//    }
    
    
    func loadImage(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }

            DispatchQueue.main.async(execute: {

                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)

                    self.image = downloadedImage
                }
            })
        }).resume()
    }
    
    
    
    
}
