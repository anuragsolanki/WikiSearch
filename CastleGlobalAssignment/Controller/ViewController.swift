//
//  ViewController.swift
//  CastleGlobalAssignment
//
//  Created by Anurag Solanki on 05/06/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import UIKit
import MagicalRecord

class ViewController: UIViewController, UISearchBarDelegate {
    
    var results: [WikiResult] = []
    
    var searchField: UISearchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var savedTexts: [SearchText] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.estimatedRowHeight = 100
        tableView.keyboardDismissMode = .interactive
        
        self.searchField.translatesAutoresizingMaskIntoConstraints = false
        self.searchField.searchBarStyle = .minimal
        self.searchField.delegate = self
        navigationItem.titleView = searchField
        
        populateSavedSearches()
    }

    
    // MARK:- Search Bar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Make an API Call and refresh the entries based on the text
        WebHelper.sharedInstance.loadResults(queryString: searchText, completion: { [weak self]
            (entries) in
            self?.results = entries
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchField.resignFirstResponder()
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Results"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultsTableViewCell = self.tableView?.dequeueReusableCell(withIdentifier: Constants.Identifier.TableView.cell) as! ResultsTableViewCell
        let model = results[indexPath.row]
        cell.initializeWithResult(result: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = results[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.ViewController.detail) as! DetailVC
        detailVC.result = model
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedTexts.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.CollectionView.cell, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.titleLabel.text = savedTexts[indexPath.row].text
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let selectedText = savedTexts[indexPath.row]
        onTapOfSavedSearch(text: selectedText)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = savedTexts[indexPath.row].text ?? " "
        var calculatedWidth: CGFloat = 60.0
        let font = UIFont.systemFont(ofSize: 17)
        let nameBoundingBox = NSString(string: text).size(attributes: [NSFontAttributeName: font])
        calculatedWidth = nameBoundingBox.width + 15
        return CGSize(width:calculatedWidth, height:40.0)
    }

}


extension ViewController {      // For Saved Searches
    
    func populateSavedSearches() {
        let texts = SearchText.mr_findAll()
        self.savedTexts = texts as! [SearchText]
        collectionView.reloadData()
    }
    
    // MARK:- Save button
    @IBAction func saveTapped() {
        if results.count == 0 {
            return
        }
        
        let predicate = NSPredicate(format: "text == %@", argumentArray: [searchField.text ?? " "])
        let resultingText = SearchText.mr_findAll(with: predicate)
        if let savedText = resultingText, savedText.count > 0 {
            return
        }
        
        // Fetch all saved text and check for 20 count
        let number = SearchText.mr_numberOfEntities()
        if number.intValue >= 20 {
            let oldSearch = SearchText.mr_findFirst()
            oldSearch?.mr_deleteEntity()
        }
        
        // Save this result
        guard let txt = searchField.text else {
            return
        }
        MagicalRecord.save({ (localContext) in
            let newText = SearchText.mr_createEntity(in: localContext)
            newText?.text = txt
            for res in self.results {
                let newResult = SearchResult.mr_createEntity(in: localContext)
                newResult?.searchText = newText
                newResult?.title = res.title
                newResult?.summary = res.summary
                newResult?.thumbnailImageUrl = res.thumbnailImageURL
                newResult?.pageId = Int32(res.pageId)
                newResult?.pageImage = res.pageImage
//                newResult?.timeStamp = NSDate()
            }
        }) { (success, error) in
            // Update top UI
            print(SearchText.mr_findAll() ?? "asasasasa")
            self.populateSavedSearches()
        }
        
    }
    
    func onTapOfSavedSearch(text: SearchText) {
        if results.count > 1 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        searchField.text = ""
        results.removeAll()
        let allResults = text.results
        for res in allResults! {
            var newResult: WikiResult!
            if let result = res as? SearchResult {
            newResult = WikiResult(title: result.title ?? "", summary: result.summary ?? "", thumbnailImageURL: result.thumbnailImageUrl, pgId: Int(result.pageId), pgImg: result.pageImage)
            }
            results.append(newResult)
        }

        tableView.reloadData()

    }

}


