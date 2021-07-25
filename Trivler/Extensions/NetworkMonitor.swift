//
//  NetworkConnectivity.swift
//  Trivler
//
//  Created by Tej Guntuku on 7/19/21.
//

import Network

protocol NetworkMonitorDelegate {
    func connectedToInternet()
    func notConnectedToInternet()
}

class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    
    private var status: NWPath.Status = .requiresConnection
    var delegate: NetworkMonitorDelegate?
    var connectedToInternet: Bool { status == .satisfied }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [self] path in
            
            status = path.status
            
            if path.status == .satisfied {
                print("We're connected!")
                DispatchQueue.main.async {delegate?.connectedToInternet() }
            } else {
                print("No connection.")
                DispatchQueue.main.async {delegate?.notConnectedToInternet() }
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        print("Stopped Monitoring")
        monitor.cancel()
    }
}
