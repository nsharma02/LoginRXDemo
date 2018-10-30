//
//  DataStorage.swift
//  LoginRXDemo
//
//  Created by admin on 26/10/18.
//  Copyright © 2018 NIhilent. All rights reserved.
//

import Foundation
import CoreData
class DataStorage{
    
    public static let sharedData = DataStorage()
    lazy var container : NSPersistentContainer = {
       let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (description, error) in
            
            if error != nil{
                fatalError("Could not load")
            }
        })
        return container
    }()
    
    var contextObject:NSManagedObjectContext? = nil
    
     init() {
    }
    func saveData(data : String)  {
        //contextObject = container.viewContext
        guard let context = contextObject else {return}
        let login = LoginTrack(context: context)
        login.username = data
        login.loginDate = Date()
        saveContext()
    }
    
    
    func saveContext(){
 
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        //let context = container.viewContext
        guard let context = contextObject else {return}
        if context.hasChanges{
            do{
            try context.save()
            }catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
