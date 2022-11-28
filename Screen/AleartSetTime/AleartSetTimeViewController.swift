//
//  AleartSetTimeViewController.swift
//  DemoX
//
//  Created by Nam Nguyễn on 27/11/2022.
//

import UIKit

protocol SetTimeDelegate: AnyObject {
    func handleSetTime(time: String)
}

class AleartSetTimeViewController: BaseVC {
    
    var delegate: SetTimeDelegate? = nil

    @IBOutlet weak var aleartView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var powerTextField: UITextField!
    
    @IBOutlet weak var setAgainOutlet: UIButton!
    @IBOutlet weak var setOutlet: UIButton!
    
    @IBAction func dissMissView(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func setAgain(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        if #available(iOS 15, *) {
            self.powerTextField.text = dateFormatter.string(from: Date.now)
        } else {
            print("Error")
        }
    }
    
    @IBAction func setTime(_ sender: Any) {
        delegate?.handleSetTime(time: powerTextField.text ?? "")
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        powerTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
        aleartView.layer.cornerRadius = 10
        powerTextField.layer.borderWidth = 2
        powerTextField.layer.borderColor = #colorLiteral(red: 0.4769712687, green: 0.5960369706, blue: 0.7423576117, alpha: 1)
        powerTextField.layer.cornerRadius = 5
        view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    override func viewDidLayoutSubviews() {
        let path = UIBezierPath(roundedRect: containerView.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 10, height:  10))

        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.powerTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
            self.powerTextField.text = dateFormatter.string(from: datePicker.date)
        }
        self.powerTextField.resignFirstResponder()
     }
}
