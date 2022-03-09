//
//  CustomCell.swift
//  CoreDataExample
//
//  Created by navaneeth-pt4855 on 09/03/22.
//

import Foundation
import UIKit
import CoreData

class CustomCell: UITableViewCell{
    
    var users:[CoreExample] = []
    
    var referenceVc: UIViewController?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var fetchResultContoller: NSFetchedResultsController<CoreExample> = {
        
        let request = CoreExample.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Name"
//        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        label.text = "Name"
//        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collection.backgroundColor = .systemTeal
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        applyCollectionViewConstraints()
        collectionView.register(CustomCollectionCell.self, forCellWithReuseIdentifier: CustomCollectionCell.cellReuseIdendifier)
//        applyConstraints()
    }
    
    func applyCollectionViewConstraints(){
        
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
    }
    
    func applyConstraints(){
        contentView.addSubview(nameLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
        ])
        
        NSLayoutConstraint.activate([
            idLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
        ])
        
        NSLayoutConstraint.activate([
//            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
//        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionCell.cellReuseIdendifier, for: indexPath) as! CustomCollectionCell
        
//        cell.backgroundColor = UIColor(
        let user = users[indexPath.item]
         
            cell.nameLabel.text = user.name
            cell.idLabel.text = "ID: \(user.rollNumber)"
            cell.dateLabel.text = (user.createdAt?.formatted(date: .numeric, time: .shortened))!
 //            cell.textLabel?.text = "\(user.name!)"
 //           cell.detailTextLabel?.text = "Created on: \((user.createdAt?.formatted(date: .numeric, time: .shortened))!)"
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        do{
            try fetchResultContoller.performFetch()
            let data = users[indexPath.item]

                let sheet = UIAlertController(title: "Edit or Delete", message: nil, preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in

                    let ac = UIAlertController(title: (data.name)!, message: nil, preferredStyle: .alert)

                    ac.addTextField { textField in
                        textField.text = (data.name)!
                    }

                    ac.addAction(UIAlertAction(title: "Change", style: .default, handler: { action in

                        let text = ac.textFields?.first?.text!

                        data.name = text
                        (self.referenceVc as! ViewController).saveCoreData()
                        
                    }))

                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

//                    ViewController.presentViewController(ac, animated: true)
                    self.referenceVc!.present(ac, animated: true)
                }))

                sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in

                    let ac = UIAlertController(title: "Delete \((data.name)!)?", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] action in

                       let item = self.users[indexPath.item]

                        users.remove(at: indexPath.item)
                            self.context.delete(item)
                            (referenceVc as! ViewController).saveCoreData()
                        (referenceVc as! ViewController).tableView.reloadData()
                        (referenceVc as! ViewController).getCoreData()
                        self.collectionView.reloadData()

                    }))

                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.referenceVc!.present(ac,animated: true)
                }))

                sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.referenceVc!.present(sheet, animated: true)


        }catch {

        }

    }
    
    func reloadData(){
        collectionView.reloadData()
    }
    
    func saveCoreData(){
         if context.hasChanges{
             do{
                 try context.save()
                
             }catch let saveError{
                 //error while saving in coreData
                 print("Not saved in coreData",saveError)
                
             }
         }
         
     }
}

