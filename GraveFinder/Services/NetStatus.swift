//
//  NetStatus.swift
//  GraveFinder
//
//  Created by Erik Westervind on 2020-12-11.
//

import Foundation
import Network

class NetStatus: ObservableObject {
    
    static let shared = NetStatus()
    
    @Published var noInternet = true
    var monitor: NWPathMonitor?
    
    var isMonitoring = false
    
    var didStartMonitoringHandler: (() -> Void)?
    
    var didStopMonitoringHandler: (() -> Void)?
    
    var netStatusChangeHandler: (() -> Void)?
    
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }
        
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }
    
    var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    
    var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    
    private init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            self.netStatusChangeHandler?()
            
            switch path.status {
            case .satisfied:
                DispatchQueue.main.async {
                    self.noInternet = false
                    print("📲 Yay! We have internet!")
                }
               
            case .unsatisfied:
                DispatchQueue.main.async {
                    print("📲 No?! Where is the internet?!")
                    self.noInternet = true
                }
            case .requiresConnection:
                print("📲 Need conncection")
            default:
                print("📲 Connection info")
            }
        }
        
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    
    func stopMonitoring() {
        print("Stopped monitoring network")
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        didStopMonitoringHandler?()
    }
}
