//
//  ProfileViewController.swift
//  RecipeNoteApp
//
//  Created by Julian Sanchez on 2022-05-24.
//

import UIKit

class ProfileViewController: UIViewController {

    //user defaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "stayLoggedIn")
        guard let nextScreen = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else{
            print("Cannot find next screen")
            return
        }
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }

}
