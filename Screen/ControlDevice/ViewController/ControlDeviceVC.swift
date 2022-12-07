//
//  ControlDeviceVC.swift
//  DemoX
//
//  Created by cmc on 18/11/2022.
//

import UIKit
import iCOM_Service

class ControlDeviceVC: BaseVC, ControlDeviceDelegate, ControlDeviceCellDelegate {
    
    private let viewModel = ControlDeviceViewModel()
    
    var arrItems = [[Items]]()
    var arrSection = [String]()
    var arrOnOff = [Bool]()
   
    @IBOutlet weak var collectionControlDeviceView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    private let itemsPerRow = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.loadListDevices()
        configCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func configCollectionView() {
        collectionControlDeviceView.backgroundColor = UIColor(hex: 0xEBEBF0)
        collectionControlDeviceView.register(ControlDeviceCell.nib, forCellWithReuseIdentifier: ControlDeviceCell.toNibName)
        collectionControlDeviceView.register(ControlDeviceCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ControlDeviceCollectionReusableView.toNibName)
        collectionControlDeviceView.register(TypeHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TypeHeaderView.toNibName)
        collectionControlDeviceView.register(ControlDeviceFooterView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ControlDeviceFooterView.toNibName)
    }

    override func setUpViews() {
        setTitleVC("Điều khiển thiết bị".uppercased())
        setRightButtonBar()
        setBackButtonBar()
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
            arrItems = StoreData.shared.getListItems() ?? [[Items]]()
            arrSection = StoreData.shared.getListSections() ?? [String]()
            getOnOffValue()
            arrOnOff = StoreData.shared.getListOnOff() ?? [Bool]()
            collectionControlDeviceView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    func didPressButton(_ tag: Int) {
        let vc = ListAlarmVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleSwitchAction(_ tag: Int) {
    }
    
    func getOnOffValue() {
        var onOffList = [Bool]()
        
        for arrItemSection in arrItems {
            var check = true
            for item in arrItemSection {
                if !(item.status ?? false) {
                    check = false
                }
            }
            onOffList.append(check)
        }
        
        StoreData.shared.setListOnOff(listOnOff: onOffList)
        
        arrOnOff = StoreData.shared.getListOnOff() ?? [Bool]()
        
        DispatchQueue.main.async {
            self.collectionControlDeviceView.reloadData()
        }
    }
}

extension ControlDeviceVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrSection.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView = UICollectionReusableView()
        let section = indexPath.section
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch section {
            case 0:
                guard let firstHeader = collectionControlDeviceView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ControlDeviceCollectionReusableView.toNibName, for: indexPath) as? ControlDeviceCollectionReusableView else {
                    return reusableView
                }
                
                firstHeader.cellDelegate = self
                firstHeader.alarmBtn.tag = indexPath.row
                firstHeader.powerConsumptionLabel.text = "\(viewModel.powerConsum) kWh"
                
                reusableView = firstHeader
            default:
                guard let secondHeader = collectionControlDeviceView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TypeHeaderView.toNibName, for: indexPath) as? TypeHeaderView else {
                    return reusableView
                }
                
                let sectionValue = arrSection[indexPath.section]
                let onOffValue = arrOnOff[indexPath.section]
                
                secondHeader.bindView(sectionName: sectionValue, onOffValue: onOffValue)
                secondHeader.onOffAllDevices.tag = indexPath.section
                secondHeader.onOffAllDevices.addTarget(self, action: #selector(onOffAllDevice), for: .valueChanged)
                
                
                reusableView = secondHeader
            }
            
            return reusableView
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionControlDeviceView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ControlDeviceFooterView.toNibName, for: indexPath) as? ControlDeviceFooterView else {
                return reusableView
            }
            
            reusableView = footer
        default:
            break
        }
        
        return reusableView
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return arrItems[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionControlDeviceView.dequeueReusableCell(withReuseIdentifier: ControlDeviceCell.toNibName, for: indexPath) as? ControlDeviceCell else {
            return UICollectionViewCell()
        }
        
        cell.cellDelegate = self
        
        let item = arrItems[indexPath.section][indexPath.row]
        cell.bindView(item: item)
        
        cell.onOffDevice.row = indexPath.row
        cell.onOffDevice.section = indexPath.section
        cell.onOffDevice.addTarget(self, action: #selector(switchTriggered), for: .valueChanged)

        return cell
    }
    
    @objc
    func switchTriggered(sender: AnyObject) {
        let switchOnOff = sender as! MySwitch
        let row = switchOnOff.row
        let section = switchOnOff.section
        
        let deviceSelected = arrItems[switchOnOff.section ?? 0][switchOnOff.row ?? 0]
        
        
        viewModel.loadOnOffDevice(mac: deviceSelected.mac ?? "", status: !(deviceSelected.status ?? false))
        
        arrItems[section ?? 0][row ?? 0].status = !(deviceSelected.status ?? false)
        
        StoreData.shared.setListItems(dictData: arrItems)
        
        getOnOffValue()
    }
    
    @objc
    func onOffAllDevice(sender: AnyObject) {
        let switchOnOff = sender as! UISwitch
        let deviceSelected = arrItems[switchOnOff.tag]
        
        if !arrOnOff[switchOnOff.tag] {
            for (index, item) in deviceSelected.enumerated() {
                viewModel.loadOnOffDevice(mac: item.mac ?? "", status: true)
                
                arrItems[switchOnOff.tag][index].status = true
            }
        } else {
            for (index, item) in deviceSelected.enumerated() {
                viewModel.loadOnOffDevice(mac: item.mac ?? "", status: false)
                
                arrItems[switchOnOff.tag][index].status = false
            }
        }
        
        
        StoreData.shared.setListItems(dictData: arrItems)
        
        getOnOffValue()
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
        if arrItems[indexPath.section].count > 1 {
            let paddingSpace = self.sectionInsets.left * CGFloat(self.itemsPerRow - 1)
            let availableWith = self.view.frame.width - paddingSpace
            let widthPerItem = availableWith / CGFloat(self.itemsPerRow)
            return CGSize(width: widthPerItem, height: 100)
        } else {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 470)
        }
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeZero
        }
        return CGSize(width: collectionView.frame.width, height: 1)
    }
}

class MySwitch: UISwitch {
    var row: Int?
    var section: Int?
}
