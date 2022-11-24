//
//  AddSchedulerVC.swift
//  DemoX
//
//  Created by cmc on 18/11/2022.
//

import UIKit

class AddSchedulerVC: BaseVC {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var addDeviceBtn: UIButton!
    @IBOutlet weak var changeLoopControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    @IBAction func moveToChooseDevice(_ sender: Any) {
        let vc = SelectDeviceVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func moveToTurnDevice(_ sender: Any) {
        let vc = TurnDeviceVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func setUpViews() {
        setTitleVC("Thêm mới lịch".uppercased())
        setRightButtonBar()
        setBackButtonBar()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.shadowColor = .clear
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor(red: 0.025, green: 0.495, blue: 0.974, alpha: 1.00)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            navigationItem.compactAppearance = appearance
        } else {
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
        }
        datePicker.backgroundColor = UIColor(red: 0.251, green: 0.302, blue: 0.318, alpha: 1.00)
        datePicker.layer.cornerRadius = 20
        datePicker.layer.masksToBounds = true
        let titleNormalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.251, green: 0.302, blue: 0.318, alpha: 1.00)]
        let titleSelectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        changeLoopControl.setTitleTextAttributes(titleNormalTextAttributes, for: .normal)
        changeLoopControl.setTitleTextAttributes(titleSelectedTextAttributes, for: .selected)
        changeLoopControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        addDeviceBtn.setTitle("", for: .normal)
        addDeviceBtn.setTitle("", for: .disabled)
        addDeviceBtn.setTitle("", for: .highlighted)
        addDeviceBtn.setTitle("", for: .selected)
        addDeviceBtn.setImage(UIImage(named: "ic_arrow"), for: .normal)
        actionBtn.setTitle("", for: .normal)
        actionBtn.setTitle("", for: .disabled)
        actionBtn.setTitle("", for: .highlighted)
        actionBtn.setTitle("", for: .selected)
        actionBtn.setImage(UIImage(named: "ic_arrow"), for: .normal)
        
        
        cancelBtn.setTitle("HỦY BỎ", for: .normal)
        cancelBtn.setTitle("HỦY BỎ", for: .disabled)
        cancelBtn.setTitle("HỦY BỎ", for: .highlighted)
        cancelBtn.setTitle("HỦY BỎ", for: .selected)
        cancelBtn.layer.cornerRadius = 6
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor(red: 0.000, green: 0.471, blue: 0.906, alpha: 1.00).cgColor
        cancelBtn.setTitleColor(UIColor(red: 0.000, green: 0.471, blue: 0.906, alpha: 1.00), for: .normal)
        cancelBtn.setTitleColor(UIColor(red: 0.000, green: 0.471, blue: 0.906, alpha: 1.00), for: .disabled)
        cancelBtn.setTitleColor(UIColor(red: 0.000, green: 0.471, blue: 0.906, alpha: 1.00), for: .highlighted)
        cancelBtn.setTitleColor(UIColor(red: 0.000, green: 0.471, blue: 0.906, alpha: 1.00), for: .selected)
      
        
        saveBtn.setTitle("LƯU", for: .normal)
        saveBtn.setTitle("LƯU", for: .disabled)
        saveBtn.setTitle("LƯU", for: .highlighted)
        saveBtn.setTitle("LƯU", for: .selected)
        saveBtn.layer.cornerRadius = 6
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.setTitleColor(UIColor.white, for: .disabled)
        saveBtn.setTitleColor(UIColor.white, for: .highlighted)
        saveBtn.setTitleColor(UIColor.white, for: .selected)
        scrollView.keyboardDismissMode = .onDrag

    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        if changeLoopControl.selectedSegmentIndex == 0 {
            print("Select 0")
        } else {
            let vc = ChooseLoopTypeVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
