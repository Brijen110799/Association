//
//  CustomUITextField.swift
//  Finca
//
//  Created by CHPL Group on 18/08/21.
//  Copyright © 2021 Silverwing. All rights reserved.
//

import Foundation
import UIKit
class CustomUITextField: UITextField {
   override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
   }
}
