//
//  NetworkMonitor.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 28.08.2025.
//

import Foundation
import Network

protocol NetworkMonitorable {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

class NetworkMonitor: NetworkMonitorable {
    static let shared = NetworkMonitor()
    
    private var monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitoringQueue")

    
    private(set) var isConnected: Bool = false
    
    private init() { monitor = NWPathMonitor() }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    deinit { stopMonitoring() }
}
