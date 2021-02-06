//
//  DataBinding.swift
//  CanadaApp
//
//  Created by CVN on 06/02/21.
//

import Foundation

class DataBinding<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
    deinit {
        observer = nil
    }
}
