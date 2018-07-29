//
//  MarketPhoto.swift
//  MarketGallery
//
//  Created by MyScrap on 7/28/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import UIKit
import SDWebImage

class MarketPhoto:  MarketPhotoViewable{
    var image: UIImage?
    var title: String?
    var imageURL: String?
    
    func loadImageWithCompletionHandler(_ completion: @escaping MarketPhotoViewable.imageHandler) {
        if let urlString = imageURL , let url = URL(string: urlString){
            
            SDWebImageManager.shared().cachedImageExists(for: url) { (status) in
                if status{
                    SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: url.absoluteString, done: { (image, data, type) in
                        completion(image, nil)
                    })
                } else {
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                        SDImageCache.shared().store(image, forKey: url.absoluteString)
                        completion(image, error)
                    })
                }
            }
        } else {
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: nil, progress: nil, completed: { (image, data, error, status) in
                completion(image, error)
            })
        }
    }
    
    init(_ image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
    
    init(imageURL: String, title: String) {
        self.imageURL = imageURL
        self.title = title
    }
}
