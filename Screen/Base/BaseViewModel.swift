//
//  BaseViewModel.swift
//  GSHT
//
//  Created by Leeprohacker on 11/13/19.
//  Copyright © 2019 vcomsat. All rights reserved.
//

import Foundation
import RxSwift


public class BaseViewModel {

    lazy var loadingLive: PublishSubject<Bool> = {
        return PublishSubject()
    }()
    lazy var errorLive: PublishSubject<Error> = {
        return PublishSubject()
    }()

    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
}
