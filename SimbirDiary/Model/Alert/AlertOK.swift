//
//  AlertOK.swift
//  SimbirDiary
//
//  Created by Кирилл on 13.10.2021.
//


import UIKit

@available (iOS 12, *)
extension UIViewController {
    
    func alertOk(title: String) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default)
            
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
}
