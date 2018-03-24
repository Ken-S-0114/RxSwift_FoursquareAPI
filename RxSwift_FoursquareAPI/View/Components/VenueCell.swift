//
//  VenueCellTableViewCell.swift
//  RxSwift_FoursquareAPI
//
//  Created by 佐藤賢 on 2018/03/25.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell {

  @IBOutlet weak var venueName: UILabel!
  @IBOutlet weak var venueAddress: UILabel!
  @IBOutlet weak var venueState: UILabel!
  @IBOutlet weak var venueCity: UILabel!
  @IBOutlet weak var venueIconImage: UIImageView!
  @IBOutlet weak var venueDescription: UILabel!
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
