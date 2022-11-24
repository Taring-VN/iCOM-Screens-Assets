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
        consumePower.text = "\(myData) KWH"
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
    
    @IBOutlet weak var txt1: DesignableTextField!
    
    @IBOutlet weak var txt2: DesignableTextField!
    
    @IBAction func textField1(_ sender: UITextField) {
        txt1.inputView = datePicker1
        datePicker1.addTarget(self, action: #selector(datePickerFromValueChanged1), for: .valueChanged)
    }
    
    @IBAction func textField2(_ sender: UITextField) {
        txt2.inputView = datePicker2
        datePicker2.addTarget(self, action: #selector(datePickerFromValueChanged2), for: .valueChanged)
    }
    
    @IBAction func presentView(_ sender: Any) {
        let vc = ListAlarmVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        outLetSwitch.isOn = item.status ?? false
        
        containerView.backgroundColor = .white
        
        overPower.text = "\((item.power ?? 90) - (item.powerConsumptionLimited ?? 0)) KWH"
        
        txt1.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed1))
        txt2.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed2))
        
    }
    
    @objc func doneButtonPressed1() {
        if let  datePicker = self.txt1.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            txt1.text = dateFormatter.string(from: datePicker.date)
            print(dateFormatter.string(from: datePicker.date))
        }
        self.txt1.resignFirstResponder()
     }
    
    @objc func doneButtonPressed2() {
        if let  datePicker = self.txt2.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            self.txt2.text = dateFormatter.string(from: datePicker.date)
        }
        self.txt2.resignFirstResponder()
     }
    
    override func setupBindings() {
        viewModel.pSLoadingBlockUI.bind { [weak self] isLoading in
            self?.hideIndicatorAlertDialog(isHide: !isLoading)
        }.disposed(by: disposeBag)
    }
    
    override func setUpViews() {
        navigationItem.titleView = setTitleAndSubtitle("QUẢN LÝ THIẾT BỊ", subtitle: "Điều hoà")
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
    
    @objc func datePickerFromValueChanged1(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        txt1.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func datePickerFromValueChanged2(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        txt2.text = dateFormatter.string(from: sender.date)
    }

}

extension UITextField {

   func addInputViewDatePicker(target: Any, selector: Selector) {

    let screenWidth = UIScreen.main.bounds.width

    //Add DatePicker as inputView
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    datePicker.datePickerMode = .time
    self.inputView = datePicker

    //Add Tool Bar as input AccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

    self.inputAccessoryView = toolBar
 }

   @objc func cancelPressed() {
     self.resignFirstResponder()
   }
}

