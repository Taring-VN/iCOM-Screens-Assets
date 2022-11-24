//
//  ControlDeviceVC.swift
//  DemoX
//
//  Created by cmc on 18/11/2022.
//

import UIKit
import iCOM_Service

class ControlDeviceVC: BaseVC, ControlDeviceDelegate {
    
    private let viewModel = ControlDeviceViewModel()
    
    var arrItems = [Items]()
   
    @IBOutlet weak var collectionControlDeviceView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 4.0, left: 2.0, bottom: 4.0, right: 1.0)
    private let itemsPerRow = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.loadListDevices()
        configCollectionView()
    }

    func configCollectionView() {
        collectionControlDeviceView.backgroundColor = .white
        collectionControlDeviceView.register(ControlDeviceCell.nib, forCellWithReuseIdentifier: ControlDeviceCell.toNibName)
        collectionControlDeviceView.register(ControlDeviceCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ControlDeviceCollectionReusableView.toNibName)
        collectionControlDeviceView.register(ControlDeviceFooterView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ControlDeviceFooterView.toNibName)
    }

    override func setUpViews() {
        setTitleVC("Điều khiển thiết bị".uppercased())
        setRightButtonBar()
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
    }
    
    override func setupBindings() {
        viewModel.pSLoadingBlockUI.bind { [weak self] isLoading in
            self?.hideIndicatorAlertDialog(isHide: !isLoading)
        }.disposed(by: disposeBag)
        
        viewModel.pSGetList.bind { [unowned self] _ in
            arrItems = StoreData.shared.getListItems() ?? [Items]()
            collectionControlDeviceView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    func didPressButton(_ tag: Int) {
        let vc = ListAlarmVC()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ControlDeviceVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ControlDeviceCollectionReusableView.toNibName, for: indexPath) as? ControlDeviceCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            header.cellDelegate = self
            header.alarmBtn.tag = indexPath.row
            
            header.powerConsumptionLabel.text = "\(viewModel.powerConsum) kWh"
            
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ControlDeviceFooterView.toNibName, for: indexPath) as? ControlDeviceFooterView else {
                return UICollectionReusableView()
            }
            
            return footer
        default:
            assert(false, "Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allListDevices.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControlDeviceCell.toNibName, for: indexPath) as? ControlDeviceCell else {
            return UICollectionViewCell()
        }
        
        if let item = StoreData.shared.getListItems()?[indexPath.row] {
            cell.bindView(item: item)
        }
        
        cell.onOffDevice.tag = indexPath.row
        cell.onOffDevice.addTarget(self, action: #selector(switchTriggered), for: .valueChanged )

        return cell
    }
    
    @objc
    func switchTriggered(sender: AnyObject) {

        let switchOnOff = sender as! UISwitch
        let deviceSelected = arrItems[switchOnOff.tag]
        
        viewModel.loadOnOffDevice(mac: deviceSelected.mac ?? "", status: !(deviceSelected.status ?? false))
        
        arrItems[switchOnOff.tag].status = !(deviceSelected.status ?? false)
        
        StoreData.shared.setListItems(dictData: arrItems)
        
        print(StoreData.shared.getListItems())
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = HomeViewController()
        vc.item = viewModel.allListDevices[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ControlDeviceVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = self.sectionInsets.left * CGFloat(self.itemsPerRow - 1)
        let availableWith = self.view.frame.width - paddingSpace
        let widthPerItem = availableWith / CGFloat(self.itemsPerRow)
        return CGSize(width: widthPerItem, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 650) //add your height here
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 180) //add your height here
        }
}


