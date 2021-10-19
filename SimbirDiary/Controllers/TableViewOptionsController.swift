//
//  TableViewOptionsController.swift
//  SimbirDiary
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit
import RealmSwift

@available(iOS 13.413.4, *)
class TableViewOptionsController: UITableViewController, UITextViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textViewFullTitle: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    let labelChekDate: String = "1"
    let labelChekTime: String = "2"
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
                                              
        tableView.delegate = self
        tableView.dataSource = self
        
        saveButton.isEnabled = false
        labelDate.textColor = .lightGray
        labelTime.textColor = .lightGray
        
        textFieldTitle.delegate = self
        
        updateSabeButtonState()
        
        textViewFullTitle.delegate = self
        textViewFullTitle.textColor = UIColor.lightGray
    }
    
    private func updateSabeButtonState() {
        let titleTF = textFieldTitle.text ?? ""
        saveButton.isEnabled =  !titleTF.isEmpty && labelDate.text != "Выберите дату" && labelTime.text != "Выберите время"
    }
    
    @IBAction func checkSaveButton(_ sender: UITextField) {
        updateSabeButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldTitle.resignFirstResponder()
        return true
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        self.viewModel.viewTFFullName = textViewFullTitle.text!
        self.viewModel.viewTFName = textFieldTitle.text!
        RealmManager.shared.saveViewModel(model: viewModel)
        viewModel = ViewModel()
        alertOk(title: "Задание успешно создано!")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: alertDate(label: labelDate) {(numberWeekday, date) in
            self.viewModel.viewDate = date
            self.viewModel.viewWeekday = numberWeekday
            self.labelDate.text = self.labelChekDate
            if self.labelDate.text == "1" {
                self.labelDate.textColor = .black
            }
            self.updateSabeButtonState()
        }
        case 1: alertTime(label: labelTime) {(time) in
            self.viewModel.viewTime = time
            self.labelTime.text = self.labelChekTime
            if self.labelTime.text == "2" {
                self.labelTime.textColor = .black
            }
            self.updateSabeButtonState()
        }
        default:
            print("Error")
        }
    }
    
    func textViewDidBeginEditing(_ textViewFullTitle: UITextView) {
        if textViewFullTitle.textColor == UIColor.lightGray {
            textViewFullTitle.text = nil
            textViewFullTitle.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textViewFullTitle: UITextView) {
        if textViewFullTitle.text.isEmpty {
            textViewFullTitle.text = "Заметка"
            textViewFullTitle.textColor = UIColor.lightGray
        }
    }
}
