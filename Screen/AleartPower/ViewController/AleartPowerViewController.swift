//
//  AleartPowerViewController.swift
//  DemoX
//
//  Created by Nam Nguyễn on 23/11/2022.
//

import UIKit
import iCOM_Service

protocol MyDataSendingDelegateProtocol: AnyObject {
    func sendDataToFirstViewController(myData: String)
}

class AleartPowerViewController: BaseVC {
    private let viewModel = AleartPowerViewModel()
    weak var delegate: MyDataSendingDelegateProtocol? = nil
    
    var item = Items()

    @IBOutlet weak var aleartView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var powerTextField: UITextField!
    
    @IBOutlet weak var setAleartOutlet: UIButton!
    
    @IBAction func dissMissView(_ sender: Any) {
        dismiss(animated: false)
    }
    
    
    @IBAction func setAleartPower(_ sender: Any) {
        viewModel.loadAleartPower(item: item, powerLimited: powerTextField.text ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        powerTextField.delegate = self
        aleartView.layer.cornerRadius = 10
        powerTextField.layer.borderWidth = 2
        powerTextField.layer.borderColor = #colorLiteral(red: 0.4769712687, green: 0.5960369706, blue: 0.7423576117, alpha: 1)
        powerTextField.layer.cornerRadius = 5
        view.backgroundColor = .black.withAlphaComponent(0.7)
        
        if powerTextField.text?.isEmpty ?? false {
            setAleartOutlet.isEnabled = false
            setAleartOutlet.backgroundColor = .darkGray
        }
    }
    
    override func setupBindings() {
        viewModel.pSLoadingBlockUI.bind { [weak self] isLoading in
            self?.hideIndicatorAlertDialog(isHide: !isLoading)
        }.disposed(by: disposeBag)
        
        viewModel.pSGetList.bind { [unowned self] _ in
            let dataToBeSent = self.powerTextField.text
            self.delegate?.sendDataToFirstViewController(myData: dataToBeSent!)
            dismiss(animated: false)
        }.disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        let path = UIBezierPath(roundedRect: containerView.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 10, height:  10))

        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }
}

extension AleartPowerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if !text.isEmpty{
            setAleartOutlet.isEnabled = true
            setAleartOutlet.backgroundColor = .systemBlue
        } else {
            setAleartOutlet.isEnabled = false
            setAleartOutlet.backgroundColor = .darkGray
        }
        return true
    }
}
