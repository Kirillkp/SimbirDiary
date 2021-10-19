//
//  PresentationContentViewController.swift
//  SimbirDiary
//
//  Created by Кирилл on 17.10.2021.
//

import UIKit

class PresentationContentViewController: UIViewController {

    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var imagePresentation: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    var topText = ""
    var imageName: String = "" {
        didSet {
            if let imageView = imagePresentation {
                imageView.image = UIImage.gifImageWithName(imageName)
            }
        }
    }
    var currentPage = 0
    var numbersOfPages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topTextLabel.textColor = .black
        
        topTextLabel.text = topText
        imagePresentation!.image = UIImage.gifImageWithName(imageName)
        pageControl.numberOfPages = numbersOfPages
        pageControl.currentPage = currentPage
    }
}
