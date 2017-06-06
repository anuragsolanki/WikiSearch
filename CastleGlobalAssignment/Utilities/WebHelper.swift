//
//  WebHelper.swift
//  CastleGlobalAssignment
//
//  Created by Anurag Solanki on 07/06/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import Foundation
import Alamofire

typealias ResultCompletion = ([WikiResult]) -> ()

final class WebHelper {
    
    // To ensure creation of single instance
    fileprivate init() {}

    static let sharedInstance = WebHelper()
    
    
    func loadResults(queryString: String, completion: @escaping ResultCompletion) {
        let requestURL = "\(Constants.URL.apiBaseURL)"
        let params = ["format": "json", "action":"query", "generator":"search", "gsrnamespace":"0", "gsrsearch":queryString, "gsrlimit":"10", "prop":"pageimages|extracts", "pilimit":"max", "exintro":"1", "explaintext":"1", "exsentences":"1", "exlimit":"max"]
        
        Alamofire.request(requestURL, parameters: params).responseJSON{ response in
            print(response.result)
            
            guard let JSON = response.result.value else {
                completion([])
                return
            }
            guard let result = (JSON as! [String: AnyObject])["query"]?["pages"] else {
                completion([])
                return
            }
            guard let pages = result as? [String: AnyObject] else {
                completion([])
                return
            }
            
            var entries: [WikiResult] = []
            for (_, value) in pages {
                let page = value as! [String: AnyObject]
                guard let title = page["title"] as? String ,
                    let subTitle = page["extract"] as? String else {
                        completion([])
                        return
                }
                
                // Save result with image
                if let url = page["thumbnail"] as? [String: AnyObject] {
                    if let urlString = url["source"] as? String {
                        let entry = WikiResult(title: title, summary: subTitle, thumbnailImageURL: urlString, pgId: page["pageid"] as? Int, pgImg: page["pageimage"] as? String)
                        entries.append(entry)
                        continue
                    }
                }
                // Save result without image
                let entry = WikiResult(title: title, summary: subTitle)
                entries.append(entry)
            }
            completion(entries)
        }
    }
}
