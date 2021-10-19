//
//  ViewTableControllers.swift
//  SimbirDiary
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

@available(iOS 13.0, *)
class ViewTableController: UITableViewCell {
    
    let timeTask = UILabel(text: "20:00", font: .avenirNext20())
    let taskName = UILabel(text: "Купить молока", font: .avenirNext20(), aligment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.overrideUserInterfaceStyle = .light
        setConstraints()
        self.selectionStyle = .none
        taskName.numberOfLines = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init coder has not been emplented")
    }
    
    func configure(model: ViewModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        timeTask.text = dateFormatter.string(from: model.viewTime)
        taskName.text = model.viewTFName
    }
    
    func setConstraints() {
        
        self.addSubview(timeTask)
        NSLayoutConstraint.activate([
            timeTask.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            timeTask.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            timeTask.widthAnchor.constraint(equalToConstant: 60),
            timeTask.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ])
        
        self.contentView.addSubview(taskName)
        NSLayoutConstraint.activate([
            taskName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            taskName.leadingAnchor.constraint(equalTo: timeTask.trailingAnchor, constant: 10),
            taskName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            taskName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ])
        
    }
    
}
