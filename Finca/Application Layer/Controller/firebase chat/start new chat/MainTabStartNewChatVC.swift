//
//  MainTabStartNewChatVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 09/03/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class MainTabStartNewChatVC: ButtonBarPagerTabStripViewController {

    var firstTime = false
    override func viewDidLoad() {
        loadDesing()
        super.viewDidLoad()
        firstTime = true
        // Do any additional setup after loading the view.
    }


    func loadDesing() {
        settings.style.buttonBarBackgroundColor = ColorConstant.colorP
//        settings.style.buttonBarItemFont = UIFont(name: "Roboto-Medium.ttf", size: 12)!
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.blue
        settings.style.selectedBarHeight = 1
       // settings.style.buttonBarItemsShouldFillAvailableWidth = true
        //settings.style.buttonBarLeftContentInset = 0
        //ettings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarHeight = 20

        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in

            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor =  #colorLiteral(red: 0.8335736207, green: 0.8335736207, blue: 0.8335736207, alpha: 1)
            newCell?.label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            oldCell?.backgroundColor = .clear
//            oldCell?.cornerRadius = 20
//            newCell?.cornerRadius = 20
            oldCell?.label.font =  oldCell?.label.font.withSize(14)
            newCell?.label.font =  newCell?.label.font.withSize(14)
//            newCell?.backgroundColor =  ColorConstant.colorP
//            oldCell?.sizeToFit()
        }
        
        
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 =  TabResidantVC()
        let child_2 = TabSecurityVC()
        return [child_1 , child_2]
        
    }
    override func viewDidAppear(_ animated: Bool) {
       // reloadPagerTabStripView()
    }

    override func viewWillAppear(_ animated: Bool) {
        if firstTime {
            firstTime = false
            reloadPagerTabStripView()
        }
   }
}
