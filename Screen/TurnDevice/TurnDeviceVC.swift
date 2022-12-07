//
//  TurnDeviceVC.swift
//  DemoX
//
//  Created by cmc on 18/11/2022.
//

import UIKit
import iCOM_Service

class TurnDeviceVC: BaseVC, SetTimeDelegate {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var turnTableView: UITableView!
    var arrTime = [String]()
    
    var mockData = [TurnData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mockData.removeAll()

        arrTime = StoreData.shared.getTime() ?? [String]()
        mockData.append(TurnData(name: "Tắt thiết bị", isSelected: true))
        mockData.append(TurnData(name: "Bật thiết bị", isSelected: false))
    }

    override func setUpViews() {
        backgroundView.backgroundColor = UIColor(red: 0.000, green: 0.471, blue: 0.906, alpha: 1.00)
        setTitleVC("Bật Tắt thiết bị".uppercased())
        setRightButtonBar()
        setBackButtonBar()
        
        turnTableView.delegate = self
        turnTableView.dataSource = self
        turnTableView.register(UINib(nibName: String(describing: LoopTypeItemCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LoopTypeItemCell.self))
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
        
    }
    
    override func viewDidLayoutSubviews() {
        let path = UIBezierPath(roundedRect: containerView.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 30, height: 30))

        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }
    
    func handleSetTime(time: String) {
        arrTime.append(time)
        StoreData.shared.saveTime(arrTime)
        mockData[0].isSelected = false
        mockData[1].isSelected = true
        
        DispatchQueue.main.async {
            self.turnTableView.reloadData()
        }
    }

}

extension TurnDeviceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoopTypeItemCell.self)) as? LoopTypeItemCell
        else { return UITableViewCell() }
        cell.fillData(model: mockData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = AleartSetTimeViewController()
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: false)
        }
    }
    
}

struct TurnData {
    let name: String
    var isSelected: Bool
}
