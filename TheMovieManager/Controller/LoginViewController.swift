//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "completeLogin", sender: nil)
        setLogginIn(true)
        TMDBClient.getRequestToken(completion: handleRequestTokenResponse(success:error:))
        
    }
    
    @IBAction func loginViaWebsiteTapped() {
        setLogginIn(true)
        TMDBClient.getRequestToken { success, error in
            if success {
              
                    UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
                
            }
        }
    }
    
    func handleRequestTokenResponse(success: Bool, error: Error?){
        if success{
            print(TMDBClient.Auth.requestToken)
           
                TMDBClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
            
         
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?){ // burdan sonra handleRequestTokenResponse icinde cagiriyorum. loginTapped icinde degil. Ayrica main thread de calismamasi icin async icinde yaziyorum.
        
        
        if success{
            print(TMDBClient.Auth.requestToken)
            TMDBClient.createSessionId( completion: handleSessionResponse(success:error:))
            
        }
    }
    
    func handleSessionResponse(success: Bool, error: Error?){ //burdan sonra da handleLoginResponse icinde cagiriyorum. cunku login dogru calistiktan sonra sessionid yaratilmasini bekliyorum.
        
        setLogginIn(false)
        if success{
            print(TMDBClient.Auth.sessionId)
            
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
        
        }
    }
    
    func setLogginIn(_ loggingIn: Bool){
        if loggingIn {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        }else{
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        loginViaWebsiteButton.isEnabled = !loggingIn
    }
}
