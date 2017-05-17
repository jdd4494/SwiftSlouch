//
//  PatientTableViewCell.swift
//  Concussion Test
//
//  Created by Justin Dambra on 5/5/16.
//  Copyright © 2016 Slouch Design. All rights reserved.
//

import UIKit

class PatientTableViewCell: UITableViewCell {
    
    // MARK: [Properties]
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
