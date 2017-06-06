//
//  SearchText+CoreDataProperties.swift
//  
//
//  Created by Anurag Solanki on 07/06/17.
//
//

import Foundation
import CoreData


extension SearchText {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchText> {
        return NSFetchRequest<SearchText>(entityName: "SearchText")
    }

    @NSManaged public var text: String?
    @NSManaged public var results: NSOrderedSet?

}

// MARK: Generated accessors for results
extension SearchText {

    @objc(insertObject:inResultsAtIndex:)
    @NSManaged public func insertIntoResults(_ value: SearchResult, at idx: Int)

    @objc(removeObjectFromResultsAtIndex:)
    @NSManaged public func removeFromResults(at idx: Int)

    @objc(insertResults:atIndexes:)
    @NSManaged public func insertIntoResults(_ values: [SearchResult], at indexes: NSIndexSet)

    @objc(removeResultsAtIndexes:)
    @NSManaged public func removeFromResults(at indexes: NSIndexSet)

    @objc(replaceObjectInResultsAtIndex:withObject:)
    @NSManaged public func replaceResults(at idx: Int, with value: SearchResult)

    @objc(replaceResultsAtIndexes:withResults:)
    @NSManaged public func replaceResults(at indexes: NSIndexSet, with values: [SearchResult])

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: SearchResult)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: SearchResult)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSOrderedSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSOrderedSet)

}
