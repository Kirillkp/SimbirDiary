//
//  PresentationPageViewController.swift
//  SimbirDiary
//
//  Created by Кирилл on 17.10.2021.
//

import UIKit

class PresentationPageViewController: UIPageViewController {

    let topTextArray = [
    "Привет, я твой личный ежедневник, чтобы тебе было удобно мной пользоваться, давай ознокомимся с моим функционалом!",
    "Развернуть календарь можно движением вниз, или нажать кнопку Открыть календарь",
    "Добавить запись можно нажатием на кнопку +",
    "Изменить описание записи можно просто нажав на нее",
    "Удалить запись можно движением влево",
    "Приятного пользования 👋🏼"
    ]
    
    let imageArray = ["6GifAnimation", "1GifAnimation", "2GifAnimation", "3GifAnimation", "4GifAnimation", "6GifAnimation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        if let contentViewController = showViewControllerAtIndex(0) {
            setViewControllers([contentViewController], direction: .forward , animated: true, completion: nil)
        }
    }

    func showViewControllerAtIndex (_ index: Int) -> PresentationContentViewController? {
        
        guard index >= 0 else {return nil}
        guard index < topTextArray.count else {
           let userDefaults = UserDefaults.standard
           userDefaults.set(true, forKey: "presentationWasViewed")
           dismiss(animated: true, completion: nil)
        return nil
       }
        guard let contentViewController = storyboard?.instantiateViewController(withIdentifier: "PresentationContentViewController") as? PresentationContentViewController else {return nil}
        contentViewController.topText = topTextArray[index]
        contentViewController.imageName = imageArray[index]
        contentViewController.currentPage = index
        contentViewController.numbersOfPages = topTextArray.count
        
        return contentViewController
    }
    
}

extension PresentationPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! PresentationContentViewController).currentPage
        pageNumber -= 1
        return showViewControllerAtIndex(pageNumber)
        
    }
     
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! PresentationContentViewController).currentPage
        pageNumber += 1
        return showViewControllerAtIndex(pageNumber)
    }
}
