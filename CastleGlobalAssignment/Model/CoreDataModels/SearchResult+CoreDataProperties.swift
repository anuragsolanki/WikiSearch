//
//  SearchResult+CoreDataProperties.swift
//  
//
//  Created by Anurag Solanki on 07/06/17.
//
//

import Foundation
import CoreData


extension SearchResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchResult> {
        return NSFetchRequest<SearchResult>(entityName: "SearchResult")
    }

    @NSManaged public var pageId: Int32
    @NSManaged public var pageImage: String?
    @NSManaged public var summary: String?
    @NSManaged public var thumbnailImageUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var timeStamp: NSDate?
    @NSManaged public var searchText: SearchText?

}
