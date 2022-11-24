//
//  ChooseLoopTypeVC.swift
//  DemoX
//
//  Created by cmc on 18/11/2022.
//

import UIKit

class ChooseLoopTypeVC: BaseVC {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loopTypeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setUpViews() {
        backgroundView.backgroundColor = UIColor(red: 0.000, green: 0.471, blue: 0.906, alpha: 1.00)
        setTitleVC("Lặp lại".uppercased())
        setRightButtonBar()
        setBackButtonBar()
        
        loopTypeTableView.delegate = self
        loopTypeTableView.dataSource = self
        loopTypeTableView.register(UINib(nibName: String(describing: LoopTypeItemCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LoopTypeItemCell.self))
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
    }
    
    var mockData: [LoopData] {
        var datas = [LoopData]()
        datas.append(LoopData(day: "Thứ 2", isSelected: true))
        datas.append(LoopData(day: "Thứ 3", isSelected: true))
        datas.append(LoopData(day: "Thứ 4", isSelected: true))
        datas.append(LoopData(day: "Thứ 5", isSelected: true))
        datas.append(LoopData(day: "Thứ 6", isSelected: false))
        datas.append(LoopData(day: "Thứ 7", isSelected: true))
        datas.append(LoopData(day: "Chủ nhật", isSelected: true))
        
        return datas
    }
    

}
extension ChooseLoopTypeVC: UITableViewDelegate, UITableViewDataSource {
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
        80
    }
    
    
}
struct LoopData {
    let day: String
    let isSelected: Bool
}
