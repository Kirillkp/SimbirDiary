//
//  AlertTime.swift
//  SimbirDiary
//
//  Created by Кирилл on 13.10.2021.
//

import UIKit

@available (iOS 12, *)
extension UIViewController {
    
    @available(iOS 13.4, *)
    func alertTime(label: UILabel, completionHandler: @escaping(Date) -> Void) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = NSLocale(localeIdentifier: "Ru_ru") as Locale
        alert.view.addSubview(datePicker)
        
        let ok = UIAlertAction(title: "Выбрать", style: .default) {(action) in
     
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let timeString = dateFormatter.string(from: datePicker.date)
            let timeShedule = datePicker.date
            completionHandler(timeShedule)
            
            label.text = timeString
             
        }
        
        let cancel = UIAlertAction(title: "Назад", style: .default, handler: nil)
        
        alert.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        alert.negativeWidthConstraint()
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}


