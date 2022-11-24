//
//  AleartPowerViewModel.swift
//  DemoX
//
//  Created by Nam Nguyễn on 24/11/2022.
//

import RxSwift
import RxCocoa
import iCOM_Service

final class AleartPowerViewModel: BaseViewModel {
    let pSLoadingBlockUI = PublishSubject<Bool>()
    let pSGetList = PublishSubject<String>()
    
    private var disposeRq: Disposable?
    
    deinit {
        disposeRq?.dispose()
    }
}

extension AleartPowerViewModel {

    func loadAleartPower(item: Items, powerLimited: String) {
        self.pSLoadingBlockUI.onNext(true)
        
        let request = AleartModel.AleartPower(id: item.id ?? 0,
                                              name: item.name ?? "",
                                              macAddress: item.mac ?? "",
                                              ip: item.ip ?? "",
                                              version: item.version ?? "",
                                              hub_id: item.hubId ?? 0,
                                              productId: item.productId ?? 0,
                                              address: item.address ?? "",
                                              ext_dev_id: item.extDevId ?? 0,
                                              status: item.status ?? false,
                                              powerConsumptionLimited: powerLimited)
        
        APIClient.shared.aleartPower(params: request)
            .map({ (response) -> OnOffDevice in
                return response
            })
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [unowned self] data in
                    self.pSLoadingBlockUI.onNext(false)
                    pSGetList.onNext("")
                },
                onError: { [unowned self] error in
                    self.pSLoadingBlockUI.onNext(false)
                    print(error)
                }).disposed(by: disposeBag)
    }
}

