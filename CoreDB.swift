//
//  CoreDB.swift
//  RecipeNoteApp
//
//  Created by Julian Sanchez on 2022-05-23.
//

import Foundation
import CoreData
import UIKit

class CoreDB{
    //singleton patterm
    
    private static var shared:CoreDB?
    private let moc:NSManagedObjectContext
    private let entityName = "Recipe"
    private let entityUser = "User"
    
    static func getInstance() -> CoreDB{
        
        if shared == nil{
            //initialise the object
            shared = CoreDB(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        }
        return shared!
    
    }
    
    private init(context:NSManagedObjectContext){
        
        self.moc = context
        
    }
    
    func insertRecipe(recipeName:String, recipeIngredients:String, recipeInstructions:String){
        do{
            
            let RecipeToBeInserted = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: self.moc) as! Recipe
            
            RecipeToBeInserted.recipeTitle = recipeName
            RecipeToBeInserted.recipeIngredients = recipeIngredients
            RecipeToBeInserted.recipeInstructions = recipeInstructions
            RecipeToBeInserted.recipeID = UUID()
            RecipeToBeInserted.recipeDateCreated = Date()
            
            if self.moc.hasChanges{
                try self.moc.save()
                print(#function, "Data is saved successfully in CoreData")
            }
            
        }catch let error as NSError{
            print(#function, "Could not save the data \(error)")
        }
    }
    
    func getAllRecipe() -> [Recipe]?{
        let fetchRequest = NSFetchRequest<Recipe>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "recipeDateCreated", ascending: false)]
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            
            print(#function, "Fetched Data: \(result as [Recipe])")
            
            return result as [Recipe]
            
        }catch let error as NSError{
            print(#function, "Could not fetch the data \(error)")
        }
        
        return nil
    }
    
    func searchRecipe(recipeID:UUID) -> Recipe?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicateID = NSPredicate(format: "recipeID == %@", recipeID as CVarArg) //where clause
        fetchRequest.predicate = predicateID
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            
            if result.count > 0{
                print(#function, "Matching recipe found")
                return result.first as? Recipe
            }
            
        }catch let error as NSError{
            print(#function, "Unable to find the recipe \(error)")
        }
        
        return nil
    }
    
    func deleteRecipe(recipeID: UUID){
        //search for task using ID to obtain the object
        
        let searchResult = self.searchRecipe(recipeID: recipeID)
        
        //perform delete  operation using object, if found
        
        if(searchResult != nil){
            //matching task found
            do{
                self.moc.delete(searchResult!)
                try self.moc.save()
                
                print(#function, "Recipe deleted successfully")
                
            }catch let error as NSError{
                print(#function, "Could not delete the Recipe \(error)")
            }
        }else{
            print(#function, "No matching record found")
        }
        
    }
    
    func updateRecipe(updateRecipe: Recipe){
        let searchResult = self.searchRecipe(recipeID: updateRecipe.recipeID! as UUID)
        
        if (searchResult != nil){
            do{
                let RecipeToUpdate = searchResult!
                
                RecipeToUpdate.recipeTitle = updateRecipe.recipeTitle
                RecipeToUpdate.recipeIngredients = updateRecipe.recipeIngredients
                RecipeToUpdate.recipeInstructions = updateRecipe.recipeInstructions
                
                try self.moc.save()
                
                print(#function, "successfully updated the recipe")
                
            }catch let error as NSError{
                print(#function, "Could not update the recipe \(error)")
            }
        }else{
            print(#function, "No matching record found")
        }
    }
    
    //MARK: User
    func insertUser(username:String, email:String, password:String){
        do{
            
            let UserToBeInserted = NSEntityDescription.insertNewObject(forEntityName: entityUser, into: self.moc) as! User
            
            UserToBeInserted.username = username
            UserToBeInserted.password = password
            UserToBeInserted.email = email
            UserToBeInserted.userID = UUID()
            UserToBeInserted.isloggedIn = false
            
            
            if self.moc.hasChanges{
                try self.moc.save()
                print(#function, "Data is saved successfully in CoreData")
            }
            
        }catch let error as NSError{
            print(#function, "Could not save the data \(error)")
        }
    }
    
    func userLogIn(username:String, loginStatus:Bool){
        let searchResult = self.searchUser(username: username)
        
        //perform delete  operation using object, if found
        
        if(searchResult != nil){
            //matching task found
            do{
                
                let UserToUpdate = searchResult!
                
                UserToUpdate.isloggedIn = loginStatus
                
                try self.moc.save()
                
                print(#function, "User login status changed successfully")
                
            }catch let error as NSError{
                print(#function, "Could not change the login status of the User \(error)")
            }
        }else{
            print(#function, "No matching record found")
        }
    }
    
    func getAllUsers() -> [User]?{
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "username", ascending: true)]
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            
            print(#function, "Fetched Data: \(result as [User])")
            
            return result as [User]
            
        }catch let error as NSError{
            print(#function, "Could not fetch the data \(error)")
        }
        
        return nil
    }
    
    func searchUser(username:String) -> User?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicateID = NSPredicate(format: "username == %@", username as CVarArg) //where clause
        fetchRequest.predicate = predicateID
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            
            if result.count > 0{
                print(#function, "Matching user found")
                return result.first as? User
            }
            
        }catch let error as NSError{
            print(#function, "Unable to find the user \(error)")
        }
        
        return nil
    }
    
    func deleteUser(username: String){
        //search for task using ID to obtain the object
        
        let searchResult = self.searchUser(username: username)
        
        //perform delete  operation using object, if found
        
        if(searchResult != nil){
            //matching task found
            do{
                self.moc.delete(searchResult!)
                try self.moc.save()
                
                print(#function, "User deleted successfully")
                
            }catch let error as NSError{
                print(#function, "Could not delete the User \(error)")
            }
        }else{
            print(#function, "No matching record found")
        }
        
    }
    
    func updateUser(updateUser: User){
        let searchResult = self.searchUser(username: updateUser.username! as String)
        
        if (searchResult != nil){
            do{
                let UserToUpdate = searchResult!
                
                UserToUpdate.password = updateUser.password
                UserToUpdate.email = updateUser.email
                
                try self.moc.save()
                
                print(#function, "successfully updated the user")
                
            }catch let error as NSError{
                print(#function, "Could not update the user \(error)")
            }
        }else{
            print(#function, "No matching record found")
        }
    }
}
