//
//  AlarmInfoItemCell.swift
//  DemoX
//
//  Created by cmc on 18/11/2022.
//

import UIKit

class AlarmInfoItemCell: UITableViewCell {
    @IBOutlet weak var daysLb: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    @IBOutlet weak var detailLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        switchControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func fillData(model: AlarmInfo) {
        detailLb.text = model.detail
        daysLb.text = model.day
        timeLb.text = model.time
    }
}
