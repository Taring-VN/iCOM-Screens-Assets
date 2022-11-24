//
//  ControlDeviceCell.swift
//  DemoX
//
//  Created by Nam Nguyễn on 19/11/2022.
//

import UIKit
import iCOM_Service

class ControlDeviceCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var onOffDevice: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bindView(item: Items) {
        title.text = item.deviceType
        subTitle.text = item.address
        
        if let valueSwitch = item.status {
            onOffDevice.isOn = valueSwitch
        }
    }

}
