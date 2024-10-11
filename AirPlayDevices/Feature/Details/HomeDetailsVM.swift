//
//  HomeDetailsVm.swift
//  AirPlayDevices
//
//

import Foundation
import Combine


class HomeDetailsVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var details :String = ""
    func getPublicIPAddress(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://api.ipify.org?format=json") else {
            completion(nil)
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [String:String].self, decoder: JSONDecoder()).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { json in
                if let ip = json["ip"] {
                    completion(ip)
                }
            }
            .store(in: &cancellables)
        
        
    }
    
    // Function to get details about the IP address
    func getIPDetails(for ip: String) {
        guard let url = URL(string: "https://ipinfo.io/\(ip)/geo") else {
            print("Invalid URL")
            return
        }
        
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [String:String].self, decoder: JSONDecoder()).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { json in
                print("IP Details: \(json)")
                self.details = "IP \(ip) Details: \(json)"
            }
            .store(in: &cancellables)
        
    }
    
    
    
}
