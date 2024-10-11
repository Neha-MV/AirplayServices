//
//  ViewController.swift
//  AirPlayDevices
//
//

import UIKit
import AppAuth

class LoginViewController: UIViewController {

    var currentAuthorizationFlow: OIDExternalUserAgentSession?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
           
       
    }
    override func viewDidAppear(_ animated: Bool) {
        silentLogin()
    }
    @IBAction func buttonActionLogin(_ sender: Any) {
        showLoginScreen()
    }

    
    func silentLogin() {
            let loginManager = LoginManager.shared()

            // Check network availability
        if ((loginManager?.isNetworkReachable()) != nil) {
                loginManager?.silentLogin { success in
                    if success {
                        // Continue to the main app
                        self.navigateHomeScreen()
                    } else {
                        // Show login screen
                        self.showLoginScreen()
                    }
                }
            } else {
                // Force logout if network is not reachable
                loginManager?.forceLogout()
                self.showLoginScreen()
            }
        }

        func showLoginScreen() {
            // Perform login
            let loginManager = LoginManager.shared()
            loginManager?.startOAuthFlow(with: self){success,token,error in
                print("token")
                if token != nil {
                    self.navigateHomeScreen()
                }
            }
        }
    func navigateHomeScreen(){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.present(viewController, animated: false, completion: nil)
       
      
    }

}

