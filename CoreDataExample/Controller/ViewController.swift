//
//  ViewController.swift
//  CoreDataExample
//
//  Created by navaneeth-pt4855 on 08/03/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
     
    let tableView = UITableView()
    
    let cellReuseID = "cellReuseID"
    
    let customCellReuseId = "CustomCellID"
    
    var sectionTitle = [String]()
    
    var userDict:[String: [CoreExample]] = [:]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var fetchResultContoller: NSFetchedResultsController<CoreExample> = {
        
        let request = CoreExample.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: customCellReuseId)
        
        navigationItem.title = "CoreData"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUsers))
//        createUsers()
        getCoreData()
        print(sectionTitle)
//        print(datas[0].name)
        
    }
    
// getting coredata using core data class
    
    func getCoreData(){
           
        do{
            try fetchResultContoller.performFetch()
            
            if let coreData = fetchResultContoller.fetchedObjects{
                
                sectionTitle = Array(Set(coreData.compactMap({ data in
                    return String(data.name!.prefix(1)).uppercased()
                })))
                
                sectionTitle.sort()
                sectionTitle.forEach { char in
                    userDict[char] = [CoreExample]()
                }
                
                coreData.forEach { data in
                    
                    let name = data.name
                    userDict[String(name!.prefix(1))]?.append(data)
                }
                
            }
            
        }catch{
            
        }
    
    }
    
    // using NSManagedObject to store in core data
    
    func createUsers(){
        
        if let entity = NSEntityDescription.entity(forEntityName: "CoreExample", in: context){
            let user = NSManagedObject(entity: entity, insertInto: context)
            
            user.setValue("ravi", forKey: "name")
            user.setValue(Date(), forKey: "createdAt")
            user.setValue(123, forKey: "rollNumber")
            
            saveCoreData()
        }
        
    }
    
    
    //add data in coreData using CoreExample class
    
    func addData(name: String,id: Int){
        
        let coreObject = CoreExample(context: context)
        
        coreObject.name = name
        coreObject.rollNumber = Int16(id)
        coreObject.createdAt = Date()
        
        saveCoreData()
        
        self.tableView.reloadData()
        
    }
    
    
    // using CoreExample class created by Xcode

    func fetchUser(name: String){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreExample")
        do{
            let result = try context.fetch(request) as [CoreExample]
            self.saveCoreData()
        }catch{
            // errors are handled here
            print(error)
        }
    }
    
    
    func saveCoreData(){
        if context.hasChanges{
            do{
                try context.save()
                try fetchResultContoller.performFetch()
                getCoreData()
                print(fetchResultContoller.fetchedObjects?.count)
                self.tableView.reloadData()
            }catch let saveError{
                //error while saving in coreData
                
                print("Not saved in coreData",saveError)
            }
        }
        
    }
    
    
    @objc func addUsers(){
        
        let ac = UIAlertController(title: "Add User", message: "add user name and id", preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "Enter your name here"
        }
        ac.addTextField { textField in
            textField.placeholder = "Enter your id"
        }
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            
            if let name = ac.textFields?.first?.text, let id = ac.textFields?.last?.text{
                
                DispatchQueue.main.async {
                    self.addData(name: name, id: Int(Int16(id)!))
//                    self.tableView.reloadData()
                }
            }
            
            
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(ac, animated: true)
    }
    
    
//MARK: - Tableview delegates and datasources
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        getCoreData()
        return userDict[sectionTitle[section]]?.count ?? 0
        
        //return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellReuseID)
        let cell = tableView.dequeueReusableCell(withIdentifier: customCellReuseId, for: indexPath) as! CustomCell
        
       if let user = userDict[sectionTitle[indexPath.section]]?[indexPath.row]
        {
           cell.nameLabel.text = user.name
           cell.idLabel.text = "ID: \(user.rollNumber)"
           cell.dateLabel.text = (user.createdAt?.formatted(date: .numeric, time: .shortened))!
//            cell.textLabel?.text = "\(user.name!)"
//           cell.detailTextLabel?.text = "Created on: \((user.createdAt?.formatted(date: .numeric, time: .shortened))!)"
       }
        return cell
        
    }
    
   
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10)
//        headerView.backgroundColor = .lightGray
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let headerView = view as? UITableViewHeaderFooterView{
            headerView.contentView.backgroundColor = .systemTeal
            headerView.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitle[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        do{
            try fetchResultContoller.performFetch()
            if let data = userDict[sectionTitle[indexPath.section]]?[indexPath.row]{
                
                let sheet = UIAlertController(title: "Edit or Delete", message: nil, preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                    
                    let ac = UIAlertController(title: (data.name)!, message: nil, preferredStyle: .alert)
                    
                    ac.addTextField { textField in
                        textField.text = (data.name)!
                    }
                    
                    ac.addAction(UIAlertAction(title: "Change", style: .default, handler: { action in
                        
                        let text = ac.textFields?.first?.text!
                        
                        data.name = text
                        self.saveCoreData()
                    }))
                    
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    
                    
                    self.present(ac, animated: true)
                }))
                
                sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                    
                    let ac = UIAlertController(title: "Delete \((data.name)!)?", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] action in
                        
                        if let item = self.userDict[sectionTitle[indexPath.section]]?[indexPath.row]{
                            
                            self.context.delete(item)
                            self.saveCoreData()
                        }
                        
                    }))
                    
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(ac,animated: true)
                }))
                
                sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(sheet, animated: true)
            }
            
        }catch {
            
        }
        
        
        
        
        
    }
    
}

