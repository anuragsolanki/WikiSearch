//
//  Constants.swift
//  CastleGlobalAssignment
//
//  Created by Anurag Solanki on 07/06/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import Foundation

@objc class Constants: NSObject {
    
    struct Identifier {
        
        struct ViewController {
            static let detail = "DetailVC"
        }
        
        struct TableView {
            static let cell = "ResultsCell"
        }
        
        struct CollectionView {
            static let cell = "CollectionCell"
        }
    }
    
    struct URL {
        static let apiBaseURL = "https://en.wikipedia.org/w/api.php"
    }
    
}
