//
//  ListAlarmVC.swift
//  DemoX
//
//  Created by cmc on 18/11/2022.
//

import UIKit
import iCOM_Service

class ListAlarmVC: BaseVC {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var listAlarmTableView: UITableView!
    
    var timeArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timeArr = StoreData.shared.getTime() ?? [String]()
        DispatchQueue.main.async {
            self.listAlarmTableView.reloadData()
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        let vc = AddSchedulerVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func setUpViews() {
        backgroundView.backgroundColor = UIColor(red: 0.000, green: 0.471, blue: 0.906, alpha: 1.00)
        setTitleVC("Hẹn giờ bật tắt thiết bị".uppercased())
        setRightButtonBar()
        setBackButtonBar()
        addButton.setTitle("", for: .normal)
        addButton.setTitle("", for: .disabled)
        addButton.setTitle("", for: .highlighted)
        addButton.setTitle("", for: .selected)
        
        listAlarmTableView.delegate = self
        listAlarmTableView.dataSource = self
        listAlarmTableView.register(UINib(nibName: String(describing: AlarmInfoItemCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AlarmInfoItemCell.self))
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
                                cornerRadii: CGSize(width: 30, height:  30))

        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }
    
    var mockData: [AlarmInfo] {
        var datas = [AlarmInfo]()
        datas.append(AlarmInfo(time: "9:00", detail: "HPD Journey Mapping Workshop", day: "FRI, TUE, SAT"))
        datas.append(AlarmInfo(time: "1:00", detail: "Social Service Innovation Center Logout", day: "FRI, TUE, SAT"))
        datas.append(AlarmInfo(time: "21:00", detail: "Social Service Innovation Center Logout", day: "FRI, TUE, SAT"))
        datas.append(AlarmInfo(time: "16:00", detail: "Social Service Innovation Center Logout", day: "FRI, TUE, SAT"))
        datas.append(AlarmInfo(time: "11:00", detail: "Social Service Innovation Center Logout", day: "FRI, TUE, SAT"))
        datas.append(AlarmInfo(time: "14:00", detail: "Social Service Innovation Center Logout", day: "FRI, TUE, SAT"))
        datas.append(AlarmInfo(time: "22:00", detail: "Social Service Innovation Center Logout", day: "FRI, TUE, SAT"))
        return datas
    }
    
        
}
extension ListAlarmVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        timeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AlarmInfoItemCell.self)) as? AlarmInfoItemCell
        else { return UITableViewCell() }
        
        cell.timeLb.text = timeArr[indexPath.row]
        cell.daysLb.text = "FRI, TUE, SAT"
        cell.detailLb.text = "HPD Journey Mapping Workshop"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    
}

struct AlarmInfo: Codable {
    let time: String
    let detail: String
    let day: String
}
