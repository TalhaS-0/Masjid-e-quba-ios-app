//
//  ObserverableListener.swift
//  ShifaELock
//
//  Created by Ali Waseem on 8/29/21.
//

import Foundation

class ObservableListner<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(fire: Bool = false, listener: Listener?) {
        self.listener = listener
        if fire {
            listener?(value)
        }
    }
}
