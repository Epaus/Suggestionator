//
//  ViewController.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 7/28/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate  {
    var randomizerVC =  RandomizerViewController()
    var catalogVC = SuggestionCategoryTableViewController()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        // Do any additional setup after loading the view.
    }
    
    func setupTabBar() {
        tabBarController?.delegate = self
        tabBarController?.tabBar.delegate = self
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        viewControllers = [randomizerVC, catalogVC]
        
        _ = viewControllers!.map( { $0.tabBarItem = createTabBarItems(viewController: $0) })
        
        var tag = 0
        repeat {
            viewControllers![tag].tabBarItem.tag = tag
            tag += 1
        } while tag < viewControllers!.count
        
        selectedIndex = 1
    }
    
    
    
    func createTabBarItems(viewController: UIViewController) -> UITabBarItem {
        var title: String?
        var image: UIImage?
        var selectedImage: UIImage?
        
        switch viewController {
        case randomizerVC:
            title = "Randomizer"
            image = UIImage(named: "shoutIconSmall.png")!
            selectedImage = image
        case catalogVC:
            title = "Catalog"
            image = UIImage(named: "plus_small.png")!
            selectedImage = image
        
        default:
            break
        }
        
        return UITabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("TAB BAR \(item.tag) SELECTED")
    }


}

