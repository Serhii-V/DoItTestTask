//
//  ImageCell.swift
//  TestTask
//
//  Created by Serhii on 5/25/17.
//  Copyright © 2017 SERHII. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var firstColImage: UIImageView!
    @IBOutlet weak var firstColWeather: UILabel!
    @IBOutlet weak var firstColAdress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
