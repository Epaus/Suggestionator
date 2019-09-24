//
//  ViewController.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 7/28/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UITabBarController, UITabBarControllerDelegate  {
    var randomizerVC:  RandomizerViewController
    var catalogVC = SceneCategoryController()
    var navController = UINavigationController()
   
    
    // MARK: - Lifecycle
    init(randomVC: RandomizerViewController) {
           self.randomizerVC = randomVC
           super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("\(#function) not supported!")
       }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        self.tabBar.itemPositioning = .fill
    }
    
    func setupTabBar() {
        tabBarController?.delegate = self
        tabBarController?.tabBar.delegate = self
        tabBar.barTintColor = .backgroundBlue
        tabBar.isTranslucent = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.backgroundPink], for:.normal)
         UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for:.selected)
        tabBar.unselectedItemTintColor = .backgroundPink
        tabBar.tintColor = .white
        navController = UINavigationController(rootViewController: catalogVC)
        
        viewControllers = [randomizerVC, navController] 
        
        _ = viewControllers!.map( { $0.tabBarItem = createTabBarItems(viewController: $0) })
        
        var tag = 0
        repeat {
            viewControllers![tag].tabBarItem.tag = tag
            tag += 1
        } while tag < viewControllers!.count
        
        selectedIndex = 0
    }
    
    func createTabBarItems(viewController: UIViewController) -> UITabBarItem {
        var title: String?
        var image: UIImage?
        var selectedImage: UIImage?
        
        switch viewController {
        case randomizerVC:
            title = "Randomizer"
            image = UIImage(named: "shoutIcon.png")!
            selectedImage = image
        case navController:
            title = "Catalog"
            image = UIImage(named: "catalog")!
            selectedImage = image
        
        default:
            break
        }
        
        return UITabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("TAB BAR \(item.tag) SELECTED")
        switch item.tag {
        case 1:
            print("the catalog vc")
            //catalogVC.managedContext = managedContext
        default:
            print("the spinner vc")
        }
    }
}

