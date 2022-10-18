//
//  EventDetailImageVC.swift
//  Finca
//
//  Created by Hardik on 7/23/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class EventDetailImageVC: BaseVC {
    @IBOutlet weak var ivEvent: UIImageView!
    var image : Event!
    override func viewDidLoad() {
        super.viewDidLoad()

        Utils.setImageFromUrl(imageView: ivEvent, urlString: image.eventImage)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
