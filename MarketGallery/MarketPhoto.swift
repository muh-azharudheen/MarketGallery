//
//  MarketPhoto.swift
//  MarketGallery
//
//  Created by MyScrap on 7/28/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import UIKit

class MarketPhoto:  MarketPhotoViewable{
    var image: UIImage?
    var title: String?
    
    func loadImageWithCompletionHandler(_ completion: @escaping MarketPhotoViewable.imageHandler) {
        
    }
    
    init(_ image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
    
    
}
