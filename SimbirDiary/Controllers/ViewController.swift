//
//  ViewController.swift
//  SimbirDiary
//
//  Created by Кирилл on 11.10.2021.
//

import UIKit
import FSCalendar
import RealmSwift

@available (iOS 13, *)
class ViewController: UIViewController {

    var calendarHeightConstraint: NSLayoutConstraint!
    
    let showHideButton: UIButton = {
       let button = UIButton()
        button.setTitle("Открыть календарь", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let idTableViewCell = "idTableViewCell"
    let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var calendar: FSCalendar = {
        let calenadar = FSCalendar()
        calenadar.translatesAutoresizingMaskIntoConstraints = false
        return calenadar
    }()
    
    let localRealm = try! Realm()
    var viewArray: Results<ViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        
        viewArray = localRealm.objects(ViewModel.self)
        
        calendar.delegate = self
        calendar.dataSource =  self
        calendar.scope = .week
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ViewTableController.self, forCellReuseIdentifier: idTableViewCell)
        
        setConstraints()
        
        viewOnDay(date: Date())

        showHideButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        swipeAction()
       
        self.navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        self.tableView.reloadData()
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
    //Mark: Open close FSCalendar
    @objc func showHideButtonTapped() {
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle("Свернуть календарь", for: .normal)
        } else {
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle("Открыть календарь", for: .normal)
        }
    }
    
    func swipeAction() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        calendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up: showHideButtonTapped()
        case .down: showHideButtonTapped()
        default : break
        }
    }
    
    func viewOnDay(date: Date) {
        self.tableView.reloadData()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        guard let weekday = components.weekday else { return }
        
        let dateStart = date
        let dateEnd: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: dateStart)!
        }()
        
        let predicate = NSPredicate(format: "viewWeekday = \(weekday) AND viewDate BETWEEN %@", [dateStart, dateEnd])
        viewArray = localRealm.objects(ViewModel.self).filter(predicate).sorted(byKeyPath: "viewTime")
        self.tableView.reloadData()
    }
    
    //Mark: ViewDescription
    @objc func editingTaskDescription(viewModel: ViewModel) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tableViewEditingController = storyBoard.instantiateViewController(withIdentifier: "editingOptionID") as! ViewDescriptionTaskController
        tableViewEditingController.viewModel = viewModel
        tableViewEditingController.editModel = true
        self.present(tableViewEditingController, animated: true, completion: nil)
    }
    
    //Mark: Presentation
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startPresentation()
    }

    func startPresentation(){
        let userDefaults = UserDefaults.standard
        let presentationWasViewed = userDefaults.bool(forKey: "presentationWasViewed")
        if presentationWasViewed == false {
            if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "PresentationPageViewController") as? PresentationPageViewController {
                present(pageViewController, animated: true, completion: nil)
           }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
}


//Mark: UITableViewDelegate, UITableViewDataSource
@available(iOS 13, *)
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewArray.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idTableViewCell, for: indexPath) as! ViewTableController
        let model = viewArray[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewArray[indexPath.row]
        editingTaskDescription(viewModel: model)
    }
     
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editingRow = viewArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, completionHandler in
            RealmManager.shared.deleteViewModel(model: editingRow)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

//Mark: FSCalendarDelegate, FSCalendarDataSource
@available(iOS 13, *)
extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
        calendar.locale = Locale(identifier: "Ru_ru")
        calendar.appearance.headerDateFormat = "LLLL YYYY"
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewOnDay(date: date)
    }
    
}

//Mark: Set Constraints
@available(iOS 13, *)
extension ViewController {
    
    func setConstraints() {
        view.addSubview(calendar)
        
        calendarHeightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        calendar.addConstraint(calendarHeightConstraint)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
        
        view.addSubview(showHideButton)
        NSLayoutConstraint.activate([
            showHideButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
            showHideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            showHideButton.widthAnchor.constraint(equalToConstant: 150),
            showHideButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: showHideButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}


