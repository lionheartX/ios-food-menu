//
//  CustomCell.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-07.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String?, image: UIImage?, price: String?) {
        self.name.text = name
        self.name.isHidden = (name == nil)
        self.cellImageView.image = image
        self.price.text = price
        self.price.isHidden = (price == nil)
    }
    
}
