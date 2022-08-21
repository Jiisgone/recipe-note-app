//
//  RecipeListViewController.swift
//  RecipeNoteApp
//
//  Created by Julian Sanchez on 2022-05-22.
//

import UIKit
import CoreData

class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //CoreDB
    private let coreDB = CoreDB.getInstance()
    private var recipeBook:[Recipe] = [Recipe]()
    
    //MARK: Outlets
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var recipeTable: UITableView!

    //MARK: Properties
    let defaults = UserDefaults.standard
    var currUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getAllRecipe()
        currUser = defaults.string(forKey: "username") ?? ""
        self.usernameLbl.text = currUser
        
        self.recipeTable.dataSource = self
        self.recipeTable.delegate = self
    }
    
    private func getAllRecipe(){
        let data = self.coreDB.getAllRecipe()
        if(data != nil){
            self.recipeBook = data!
            self.recipeTable.reloadData()
        }else{
            print(#function, "No data recieved from DB")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
    }
    
    //MARK: TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:  Int) -> Int {
        return self.recipeBook.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
         
         if indexPath.row < recipeBook.count{
             
             let currentRecipe  = self.recipeBook[indexPath.row]
             
             cell.recipeTitleLbl.text = currentRecipe.recipeTitle
             
             let dateFormatter = DateFormatter()
             dateFormatter.dateStyle = .short
             cell.dateCreated.text = dateFormatter.string(from: currentRecipe.recipeDateCreated!)
         }

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if(editingStyle == UITableViewCell.EditingStyle.delete && indexPath.row < self.recipeBook.count){
            self.deleteRecipeFromList(indexPath: indexPath)
        }
    }
    
//    private func updateOrderInList(indexPath: IndexPath, itemNum:Int64){
//        self.orderList[indexPath.row].quantity = itemNum
//        
//        self.coreDB.updateOrder(updateOrder: self.orderList[indexPath.row])
//        self.getAllOrders()
//    }
    
    private func deleteRecipeFromList(indexPath: IndexPath){
        self.coreDB.deleteRecipe(recipeID: self.recipeBook[indexPath.row].recipeID!)
        self.getAllRecipe()
    }
    
    @IBAction func newRecipeBtn(_ sender: Any) {
        guard let nextScreen = storyboard?.instantiateViewController(withIdentifier: "item") as? ItemViewController else{
                    print("Cannot find next screen")
                    return
                }
                self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
}
