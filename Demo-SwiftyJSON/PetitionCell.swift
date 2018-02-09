//
//  PetitionCell.swift
//  Demo-SwiftyJSON
//
//  Created by Dave on 2/9/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit

class PetitionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
