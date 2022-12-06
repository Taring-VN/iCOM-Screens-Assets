//
//  ControlDeviceCell.swift
//  DemoX
//
//  Created by Nam Nguyễn on 19/11/2022.
//

import UIKit
import iCOM_Service

protocol ControlDeviceCellDelegate : AnyObject {
    func handleSwitchAction(_ tag: Int)
}

class ControlDeviceCell: UICollectionViewCell {
    weak var cellDelegate: ControlDeviceCellDelegate?

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var onOffDevice: MySwitch!
    
    @IBAction func onOffAction(_ sender: UISwitch) {
        if sender.isOn {
            cellDelegate?.handleSwitchAction(sender.tag)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bindView(item: Items) {
        title.text = item.name
        subTitle.text = item.address
        
        if let valueSwitch = item.status {
            onOffDevice.isOn = valueSwitch
        }
    }
}
