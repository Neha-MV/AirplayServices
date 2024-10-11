//
//  AirPlayServiceDiscovery.swift
//  AirPlayDevices
//
//



import Foundation
import Network


protocol AirPlayServiceDiscoveryDelegate: AnyObject {
    func didUpdateDevices()
}
    
class AirPlayServiceDiscovery: NSObject, NetServiceBrowserDelegate, NetServiceDelegate {
    var netServiceBrowser: NetServiceBrowser!
    var discoveredServices: [AirPlayDevice] = []
    weak var delegate: AirPlayServiceDiscoveryDelegate?
    
    override init() {
        super.init()
        netServiceBrowser = NetServiceBrowser()
        netServiceBrowser.delegate = self
    }

    func startDiscovery() {
        netServiceBrowser.searchForServices(ofType: "_airplay._tcp.", inDomain: "local.")
    }

    func stopDiscovery() {
        netServiceBrowser.stop()
    }

    // MARK: - NSNetServiceBrowserDelegate

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.delegate = self
        netServiceDidResolveAddress(service)
        service.resolve(withTimeout: 5.0)
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("errordict",errorDict)
    }
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        discoveredServices.removeAll { $0.name == service.name }
        // Notify the table view to reload data here if needed
    }
    

    // MARK: - NSNetServiceDelegate

    func netServiceDidResolveAddress(_ sender: NetService) {
        if let addresses = sender.addresses {
            for address in addresses {
                var ipAddress: String?
                var addr = sockaddr_in()
                (address as NSData).getBytes(&addr, length: MemoryLayout<sockaddr_in>.size)
                ipAddress = String(cString: inet_ntoa(addr.sin_addr), encoding: .utf8)
                
                let device = AirPlayDevice(name: sender.name, ipAddress: ipAddress ?? "Unknown", status: "Reachable")
                discoveredServices.append(device)
                delegate?.didUpdateDevices() 
                // Notify the table view to reload data here
            }
        }
    }

    func netService(_ sender: NetService, didNotResolve errorDict: [String: NSNumber]) {
        let device = AirPlayDevice(name: sender.name, ipAddress: "Unknown", status: "Un-Reachable")
        discoveredServices.append(device)
        // Notify the table view to reload data here
    }
}
