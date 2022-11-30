//
//  SelectDeviceVC.swift
//  DemoX
//
//  Created by cmc on 18/11/2022.
//

import UIKit

class SelectDeviceVC: BaseVC {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var listDeviceTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func setUpViews() {
        backgroundView.backgroundColor = UIColor(red: 0.000, green: 0.471, blue: 0.906, alpha: 1.00)
        setTitleVC("chọn thiết bị".uppercased())
        setRightButtonBar()
        setBackButtonBar()
       
        
        listDeviceTableView.delegate = self
        listDeviceTableView.dataSource = self
        listDeviceTableView.register(UINib(nibName: String(describing: LoopTypeItemCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LoopTypeItemCell.self))
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
                                cornerRadii: CGSize(width: 20, height:  20))

        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
        let header = Bundle.main.loadNibNamed("LoopTypeItemCell", owner: nil, options: nil)![0] as! LoopTypeItemCell
        header.frame = CGRect(x: 0, y: 0, width: listDeviceTableView.bounds.width, height: 60)
        header.dayLb.text = "Tất cả thiết bị"
        header.dayLb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        header.dayLb.textColor = .black
        header.selectBtn.setImage(UIImage(named: "ic_select_all_iot"), for: .normal)
        listDeviceTableView.tableHeaderView = header
        
    }
    var mockData: [DeviceInfo] {
        var datas = [DeviceInfo]()
        datas.append(DeviceInfo(name: "Performed Station AE Title", isSelected: true))
        datas.append(DeviceInfo(name: "X-Ray Source ID", isSelected: false))
        datas.append(DeviceInfo(name: "Scheduled Station AE Title", isSelected: true))
        datas.append(DeviceInfo(name: "DeviceSerial", isSelected: false))
        return datas
    }

}
extension SelectDeviceVC: UITableViewDelegate, UITableViewDataSource {
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
    
    
}
struct DeviceInfo {
    let name: String
    let isSelected: Bool
}

