//
//  ViewController.swift
//  CoreDataExample
//
//  Created by navaneeth-pt4855 on 08/03/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createUsers()
        fetchUser(name: "ravi")
        
    }
    
    func createUsers(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "CoreExample", in: context){
            let user = NSManagedObject(entity: entity, insertInto: context)
            
            user.setValue("ravi", forKey: "name")
            user.setValue(Date(), forKey: "createdAt")
            user.setValue(123, forKey: "rollNumber")
            
            
            do {
                try context.save()
            }catch{
                //errors are handled here
                
                print(error)
            }
        }
        
    }
    
    func fetchUser(name: String){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreExample")
        
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                
                print(data.value(forKey: "name"))
            }
        }catch{
            // errors are handled here
            print(error)
        }
    }
    
    
}

