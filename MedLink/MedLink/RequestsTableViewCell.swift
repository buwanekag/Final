//
//  RequestsTableViewCell.swift
//  MedLink
//
//  Created by Buwaneka Galpoththawela on 11/13/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit

class RequestsTableViewCell: UITableViewCell {
    
    @IBOutlet var responseDateLabel :UILabel!
    @IBOutlet var responseTypeLabel :UILabel!
    @IBOutlet var requestNameLabel: UILabel!
    @IBOutlet var requestNameView : UITextView!
    
    
    
    //MARK: - LIFE CYCLE METHOD
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
