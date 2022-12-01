//
//  ControlDeviceCollectionReusableView.swift
//  DemoX
//
//  Created by Nam Nguyễn on 19/11/2022.
//

import UIKit

protocol ControlDeviceDelegate : class {
    func didPressButton(_ tag: Int)
}

class ControlDeviceCollectionReusableView: UICollectionReusableView {
    weak var cellDelegate: ControlDeviceDelegate?
    
    @IBOutlet weak var powerConsumptionLabel: UILabel!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var addDeviceBtn: UIButton!
    @IBOutlet weak var alarmBtn: UIButton!
    @IBOutlet weak var warningBtn: UIButton!
    @IBOutlet weak var warningLb: UILabel!
    @IBOutlet weak var changeDeviceControl: UISegmentedControl!
    
    @IBAction func actionAlarm(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configView()
    }
    
    private func configView() {
        let titleNormalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        let titleSelectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        changeDeviceControl.setTitleTextAttributes(titleNormalTextAttributes, for: .normal)
        changeDeviceControl.setTitleTextAttributes(titleSelectedTextAttributes, for: .selected)
        warningLb.layer.cornerRadius = 8
        warningLb.layer.masksToBounds = true
        addDeviceBtn.setTitle("", for: .normal)
        addDeviceBtn.setTitle("", for: .disabled)
        addDeviceBtn.setTitle("", for: .highlighted)
        addDeviceBtn.setTitle("", for: .selected)
        addDeviceBtn.setImage(UIImage(named: "ic_plus_iot"), for: .normal)
        
        alarmBtn.setTitle("", for: .normal)
        alarmBtn.setTitle("", for: .disabled)
        alarmBtn.setTitle("", for: .highlighted)
        alarmBtn.setTitle("", for: .selected)
        alarmBtn.setImage(UIImage(named: "ic_clock_iot"), for: .normal)
        
        warningBtn.setTitle("", for: .normal)
        warningBtn.setTitle("", for: .disabled)
        warningBtn.setTitle("", for: .highlighted)
        warningBtn.setTitle("", for: .selected)
        warningBtn.setImage(UIImage(named: "ic_ring_iot"), for: .normal)
    }
    
    override func draw(_ rect: CGRect) {
            cornerView.clipsToBounds = true
            cornerView.layer.cornerRadius = 10
            cornerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}
