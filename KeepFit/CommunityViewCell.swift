//
//  CommunityViewCell.swift
//  KeepFit
//
//  Created by Albert on 2021/3/26.
//

import UIKit

class CommunityViewCell: UITableViewCell {

    @IBOutlet weak var nicknameL: UILabel!
    @IBOutlet weak var zoomlinkL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
