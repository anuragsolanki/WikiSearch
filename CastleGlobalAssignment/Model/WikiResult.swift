//
//  WikiResult.swift
//  CastleGlobalAssignment
//
//  Created by Anurag Solanki on 07/06/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

typealias DownloadImageCompletion = (_ image: UIImage?) -> ()

class WikiResult {
    
    var title: String?
    var summary: String?
    var thumbnailImageURL: String?
    var thumbnailImage: UIImage?
    var pageId: Int = 0
    var pageImage: String?
    
    init(title: String, summary: String, thumbnailImageURL: String? = nil, pgId: Int? = 0, pgImg: String? = nil) {
        self.title = title
        self.summary = summary
        self.thumbnailImageURL = thumbnailImageURL
        self.pageId = pgId ?? 0
        self.pageImage = pgImg
    }
    
    
    /*
        Fetch image given a particular URL (in background)
     */
    func fetchThumbnailImage(completion: @escaping DownloadImageCompletion) {
        guard let imgUrl = self.thumbnailImageURL else { return }
        Alamofire.request(imgUrl).responseImage { response in            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.thumbnailImage = image
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
}

