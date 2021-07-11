//
//  NetworkMonitor.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 10/07/21.
//  Copyright © 2021 Arm. All rights reserved.
//

import Foundation
import Network

//Monitoring internet connection via NWPathMonitor...
class NetworkMonitor{
    static var shared: NetworkMonitor?
    
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor = NWPathMonitor()
    
    public private(set) var isConnected : Bool = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isConnected = true
                print("yes")
            } else {
                self.isConnected = false
                print("no")
            }
        }
        monitor.start(queue: self.queue)
    }
    
    func cancel() {
        monitor.cancel()
    }
    
    deinit {
        print("canceling")
        cancel()
    }
    
}
