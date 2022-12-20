//
//  HomeViewController.swift
//  DemoX
//
//  Created by Nam Nguyễn on 18/11/2022.
//

import UIKit
import RangeSeekSlider
import iCOM_Service

class HomeViewController: BaseVC, MyDataSendingDelegateProtocol {
    
    private let viewModel = ControlDeviceViewModel()
    
    var item = Items()
    
    @IBOutlet weak var nameDevice: UILabel!
    
    @IBOutlet weak var powerPercent: UILabel!
    
    @IBOutlet weak var addressDevice: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var powerView: UIView!
    
    @IBOutlet weak var outLetSwitch: UISwitch!
    
    @IBOutlet weak var consumePower: UILabel!
    
    @IBOutlet weak var overPower: UILabel!
    
    var consumePowerData = String()
    
    @IBAction func actionSwitch(_ sender: Any) {
        viewModel.loadOnOffDevice(mac: item.mac ?? "", status: !(item.status ?? true))
    }
    
    @IBAction func navigateToAleartPower(_ sender: Any) {
        let vc = AleartPowerViewController()
        vc.item = item
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }
    
    func sendDataToFirstViewController(myData: String) {
        if let number = Int(myData), number > 0 {
            let consumePowerNumber = (item.currentReport?.power ?? 0) - number
            consumePower.text = "\(consumePowerNumber) kWh"
        } else {
            consumePower.text = "\(myData) kWh"
        }
    }
    
    private lazy var datePicker1: UIDatePicker = {
      let datePicker = UIDatePicker(frame: .zero)
      datePicker.datePickerMode = .time
      datePicker.timeZone = TimeZone.current
      return datePicker
    }()
    
    private lazy var datePicker2: UIDatePicker = {
      let datePicker = UIDatePicker(frame: .zero)
      datePicker.datePickerMode = .time
      datePicker.timeZone = TimeZone.current
      return datePicker
    }()
    
    @IBAction func presentView(_ sender: Any) {
        let vc = ListAlarmVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        outLetSwitch.isOn = item.status ?? false
        
        containerView.backgroundColor = .white
        
        overPower.text = "\((item.power ?? 90) - (item.powerConsumptionLimited ?? 0)) kWh"
        
        consumePower.text = "\(item.currentReport?.power ?? 0) kWh"
        
        nameDevice.text = item.name
        addressDevice.text = item.address
    }
    
    override func setupBindings() {
        viewModel.pSLoadingBlockUI.bind { [weak self] isLoading in
            self?.hideIndicatorAlertDialog(isHide: !isLoading)
        }.disposed(by: disposeBag)
    }
    
    override func setUpViews() {
        navigationItem.titleView = setTitleAndSubtitle("QUẢN LÝ THIẾT BỊ", subtitle: String(describing: item.name ?? ""))
        setRightButtonBar()
        setBackButtonBar()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.shadowColor = .clear
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor(red: 0.000, green: 0.471, blue: 0.906, alpha: 1.00)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            navigationItem.compactAppearance = appearance
        } else {
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
        }
        
        powerView.layer.cornerRadius = 10
        powerView.layer.zPosition = 1
    }
    
    override func viewDidLayoutSubviews() {
        let path = UIBezierPath(roundedRect: containerView.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 20, height:  20))

        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }
}

extension UITextField {

   func addInputViewDatePicker(target: Any, selector: Selector) {

    let screenWidth = UIScreen.main.bounds.width

    //Add DatePicker as inputView
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    datePicker.datePickerMode = .time
    datePicker.locale = Locale.init(identifier: "vi_VN")
    self.inputView = datePicker
 }

   @objc func cancelPressed() {
     self.resignFirstResponder()
   }
}
