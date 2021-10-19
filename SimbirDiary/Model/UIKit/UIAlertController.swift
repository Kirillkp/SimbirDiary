//
//  UIAlertController.swift
//  SimbirDiary
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

extension UIAlertController {
    func negativeWidthConstraint() {
        for subView in self.view.subviews {
            for constraints in subView.constraints where constraints.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraints)
            }
        }
    }
}
