//
//  AlertDate.swift
//  SimbirDiary
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

@available (iOS 12, *)
extension UIViewController {
    
    @available(iOS 13.4, *)
    func alertDate(label: UILabel, completionHandler: @escaping(Int, Date) -> Void) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        alert.view.addSubview(datePicker)
        datePicker.locale = Locale(identifier: "Ru_ru")
        
        let ok = UIAlertAction(title: "Выбрать", style: .default) {(action) in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: datePicker.date)
            
            let calendar = Calendar.current
            let component = calendar.dateComponents([.weekday], from: datePicker.date)
            guard let weekday = component.weekday else { return }
            let numberWeekday = weekday
            let date = datePicker.date
            completionHandler(numberWeekday, date)
            
            label.text = dateString
        }
        
        let cancel = UIAlertAction(title: "Назад", style: .default, handler: nil)
        
        
        alert.negativeWidthConstraint()
        
        alert.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}
