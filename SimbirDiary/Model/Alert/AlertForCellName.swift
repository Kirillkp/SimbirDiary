//
//  AlertForCellName.swift
//  SimbirDiary
//
//  Created by Кирилл on 14.10.2021.
//

import UIKit
import SwiftUI

@available (iOS 12, *)
extension UIViewController {
    
    func alertForCellName(label: UILabel, name: String, placeholder: String, completionHandler: @escaping(String) -> Void) {
        
        let alert = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) {(action) in
            let tfAlert = alert.textFields?.first
            guard let text = tfAlert?.text else { return }
            label.text = text
            completionHandler(text)
        }
        
        alert.addTextField{ (tfAlert) in
            tfAlert.placeholder = placeholder
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
}
