//
//  TypeHeaderView.swift
//  MotherApp
//
//  Created by Nam Nguyễn on 06/12/2022.
//

import UIKit

class TypeHeaderView: UICollectionReusableView {

    @IBOutlet weak var typeDevice: UILabel!
    
    @IBOutlet weak var onOffAllDevices: UISwitch!
    
    @IBAction func onOffAllDevicesAction(_ sender: UISwitch) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindView(sectionName: String, onOffValue: Bool) {
        typeDevice.text = sectionName
        onOffAllDevices.isOn = onOffValue
    }
    
}
