//
//  BaseVC.swift
//  DemoX
//
//  Created by cmc on 18/11/2022.
//

import UIKit
import SVProgressHUD
import RxSwift

class BaseVC: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
        setupBindings()
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.000, green: 0.471, blue: 0.906, alpha: 1.00)
        navigationController?.navigationBar.tintColor = .white
    }

    func setTitleVC(_ title: String) {
        navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setTitleAndSubtitle(_ title: String, subtitle: String) -> UIView {
        let titleLabel = UILabel(frame: CGRectMake(0, -2, 0, 0))

        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = .white
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.text = title
            titleLabel.sizeToFit()

            let subtitleLabel = UILabel(frame: CGRectMake(0, 18, 0, 0))
            subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = .white
            subtitleLabel.font = UIFont.systemFont(ofSize: 12)
            subtitleLabel.text = subtitle
            subtitleLabel.sizeToFit()

            let titleView = UIView(frame: CGRectMake(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))
            titleView.addSubview(titleLabel)
            titleView.addSubview(subtitleLabel)

            let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width

            if widthDiff < 0 {
                let newX = widthDiff / 2
                subtitleLabel.frame.origin.x = abs(newX)
            } else {
                let newX = widthDiff / 2
                titleLabel.frame.origin.x = newX
            }

            return titleView
      }
    
    func setRightButtonBar(_ image: UIImage? = UIImage(named: "ic_menu")) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: image, style: .plain, target: self, action: #selector(clickLeftItem))
    }

    @objc func clickLeftItem() {
        
    }
    
    func setBackButtonBar(_ image: UIImage? = UIImage(named: "ic_back")) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setUpViews() {
    }
    
    func setupBindings() {
    }
    
    // Hide or show indicator view with block UI
    func hideIndicatorAlertDialog(isHide: Bool = false) {
        if (isHide) {
            SVProgressHUD.dismiss()
        } else {
            SVProgressHUD.show()
        }
    }
}
extension BaseVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
