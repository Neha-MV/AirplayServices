//
//  HomeDetailsViewController.swift
//  AirPlayDevices
//
//

import UIKit
import Combine

class HomeDetailsViewController: UIViewController {

    @IBOutlet weak var lableDetails: UILabel!
    var viewModel = HomeDetailsVM()
    private var cancellables = Set<AnyCancellable>()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Usage
        setupBindings()
        viewModel.getPublicIPAddress { [weak self]ip in
            guard let ip = ip else {
                print("Could not fetch IP address.")
                return
            }
            
            print("Public IP Address: \(ip)")
            self?.viewModel.getIPDetails(for: ip)
        }
    }
    
    private func setupBindings() {
            viewModel.$details
                .receive(on: DispatchQueue.main) 
                .map { $0.isEmpty ? nil : $0 }
                .assign(to: \.text, on: lableDetails) // Bind the label text to the published property
                .store(in: &cancellables)
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
