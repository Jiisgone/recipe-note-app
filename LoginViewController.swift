//
//  ViewController.swift
//  RecipeNoteApp
//
//  Created by Julian Sanchez on 2022-05-20.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: CoreDB
    private let coreDB = CoreDB.getInstance()

    //MARK: Outlets
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginSwitch: UISwitch!
    
    //Properties
//    var usern:User? = User()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        coreDB.insertUser(username: "abc", email: "abc@abc.com", password: "def")
        
        self.errorLbl.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        
        let loginStatus = self.defaults.bool(forKey: "stayLoggedIn")
        if(loginStatus)
        {
        guard let nextScreen = storyboard?.instantiateViewController(withIdentifier: "mytabBar")  else
        {
            print("could not find")
            return

        }
        self.navigationController?.pushViewController(nextScreen, animated: true)
        }
        
    }
    
    func returnUsername() -> String
    {
       
        return usernameTxt.text!
    }
    
    func returnPassword() -> String
    {
        return passwordTxt.text!
    }
    
    func isUserValid() -> Bool
    {
        var value  = false
        
        var usern = coreDB.searchUser(username: returnUsername())
        if( returnUsername() == usern?.username && returnPassword() == usern?.password){
            value = true
        }else{
            value = false
        }
        
        return value
    }
    
    //MARK: Actions
    @IBAction func loginBtnPressed(_ sender: Any) {
        print("in login")
        if(returnPassword().isEmpty == true && returnUsername().isEmpty == true)
        {
            print("Please Enter Valid Username and Password")
            self.errorLbl.text = "Please enter a valid username and password"
        }
        else if(returnUsername().isEmpty == true)
        {
            print("Please Enter Valid Username")
            self.errorLbl.text = "Please enter a valid username"
        }
        else if(returnPassword().isEmpty == true)
        {
            print("Please Enter Password")
            self.errorLbl.text = "Please enter a password"

        }
        else if(isUserValid())
        {
            //TODO: TO NEXT SCREEN
            guard let nextScreen = storyboard?.instantiateViewController(withIdentifier: "mytabBar") else
            {
                print("could not find")
                return
            }
//            nextScreen.user = self.usern!
            defaults.set(returnUsername(), forKey: "username")
            self.navigationController?.pushViewController(nextScreen, animated: true)
            print("ITS VALID USER")
            self.errorLbl.text = ""
            
            if(loginSwitch.isOn && isUserValid())
            {
                defaults.set(true, forKey: "stayLoggedIn")
            }
            if(loginSwitch.isOn == false)
            {
                defaults.set(false, forKey: "stayLoggedIn")
            }
            
        }else
        {
            print("Please Enter Valid UserName And Password")
            self.errorLbl.text = "Please enter a valid username and password"
        }
    }
        
}

