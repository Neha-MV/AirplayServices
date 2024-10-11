//
//  HomeViewController.swift
//  AirPlayDevices
//
//

import UIKit

class HomeViewController: UIViewController,AirPlayServiceDiscoveryDelegate,UITableViewDelegate,UITableViewDataSource,NetServiceBrowserDelegate {
   
    

   
    @IBOutlet weak var tableView: UITableView!
    
   // var airPlayServiceDiscovery = AirPlayServiceDiscovery()
    override func viewDidLoad() {
        super.viewDidLoad()
      //  airPlayServiceDiscovery.startDiscovery()
      
        let browser = NetServiceBrowser()
        browser.delegate = self
        browser.searchForServices(ofType: "_airplay._tcp.", inDomain: "local.")
        // Do any additional setup after loading the view.
    }
    
    func didUpdateDevices() {
        tableView.reloadData()
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        
    }
   
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("will")
    }
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("diis taop")
    }
    func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        print("find domai")
    }
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemoveDomain domainString: String, moreComing: Bool) {
         print("remove domai")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("errordict",errorDict)
    }
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        // Notify the table view to reload data here if needed
    }
    
    // MARK: - UITableViewDataSource

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)
           // let device = airPlayServiceDiscovery.discoveredServices[indexPath.row]
            
           // cell.textLabel?.text = "\(device.name) - \(device.ipAddress) - \(device.status)"
            return cell
        }
      
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeDetailsViewController") as! HomeDetailsViewController
        self.present(viewController, animated: false, completion: nil)
      
    }
}


