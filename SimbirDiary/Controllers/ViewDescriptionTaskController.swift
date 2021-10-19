//
//  ViewDescriptionTaskController.swift
//  SimbirDiary
//
//  Created by Кирилл on 15.10.2021.
//

import UIKit
import RealmSwift

@available (iOS 13, *)
class ViewDescriptionTaskController: UIViewController {
    
    @IBOutlet weak var tvDescriptionTask: UITextView!
    
    var viewModel = ViewModel()
    var editModel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        
        configureDescription(model: viewModel)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func updateTextView(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {return}
        if notification.name == UIResponder.keyboardDidHideNotification {
            tvDescriptionTask.contentInset = UIEdgeInsets.zero
        } else {
            tvDescriptionTask.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            tvDescriptionTask.scrollIndicatorInsets = tvDescriptionTask.contentInset
        }
        tvDescriptionTask.scrollRangeToVisible(tvDescriptionTask.selectedRange)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func saveTextView(_ sender: Any) {
        RealmManager.shared.editViewModel(model: viewModel, textView: tvDescriptionTask.text)
        alertOk(title: "Описание к заданию добавлено!")
    }
    
    @IBAction func backStroryBoard(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureDescription(model: ViewModel) {
        if editModel {
            tvDescriptionTask.text = model.viewTFFullName
        } else {
            tvDescriptionTask.text = "Введите описание"
        }
    }
}



