//
//  LoopTypeItemCell.swift
//  DemoX
//
//  Created by cmc on 18/11/2022.
//

import UIKit


class LoopTypeItemCell: UITableViewCell {

    @IBAction func selectTap(_ sender: Any) {
        // change here
    }
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var dayLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectBtn.setTitle("", for: .normal)
        selectBtn.setTitle("", for: .disabled)
        selectBtn.setTitle("", for: .highlighted)
        selectBtn.setTitle("", for: .selected)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillData(model: LoopData) {
        dayLb.text = model.day
        if model.isSelected {
            selectBtn.setImage(UIImage(named: "ic_selected_iot"), for: .normal)
        } else {
            selectBtn.setImage(UIImage(named: "ic_unselected_iot"), for: .normal)
        }
    }
    
    func fillData(model: TurnData) {
        dayLb.text = model.name
        if model.isSelected {
            selectBtn.setImage(UIImage(named: "ic_radio_selected_iot"), for: .normal)
        } else {
            selectBtn.setImage(UIImage(named: "ic_radio_unselected_iot"), for: .normal)
        }
    }
    
    func fillData(model: DeviceInfo) {
        dayLb.text = model.name
        if model.isSelected {
            selectBtn.setImage(UIImage(named: "ic_selected_iot"), for: .normal)
        } else {
            selectBtn.setImage(UIImage(named: "ic_unselected_iot"), for: .normal)
        }
    }
    
}
