//
//  DetailVC.swift
//  CastleGlobalAssignment
//
//  Created by Anurag Solanki on 07/06/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var pageImage: UILabel!
    
    weak var result: WikiResult!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = result.title
        subTitleLabel.text = result.summary
        pageLabel.text = "\(result.pageId)"
        pageImage.text = result.pageImage
    }



}
