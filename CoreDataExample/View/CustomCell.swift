//
//  CustomCell.swift
//  CoreDataExample
//
//  Created by navaneeth-pt4855 on 09/03/22.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell{
    
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
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        applyConstraints()
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
