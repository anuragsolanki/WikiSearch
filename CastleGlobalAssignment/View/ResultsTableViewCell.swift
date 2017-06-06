//
//  ResultsTableViewCell.swift
//  CastleGlobalAssignment
//
//  Created by Anurag Solanki on 07/06/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeWithResult(result: WikiResult) {
        title.text = result.title
        subTitle.text = result.summary
        if let _ = result.thumbnailImageURL {
            leftConstraint.constant = 16.0
            widthConstraint.constant = 80.0
            // Download image in Background thread
            DispatchQueue.global(qos: .userInitiated).async {
                _ = result.fetchThumbnailImage(completion: {[weak self] (image) in
                    DispatchQueue.main.async {
                        self?.thumbnail.image = image
                    }
                })
            }
        } else {
            leftConstraint.constant = 0
            widthConstraint.constant = 0
        }
    }


}
