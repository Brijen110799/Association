//
//  AddDiscussionCommentVC.swift
//  Finca
//
//  Created by harsh panchal on 01/05/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class AddDiscussionCommentVC: BaseVC {
    @IBOutlet weak var tfComment: UITextView!
    var placeHolder = "Title *"
    override func viewDidLoad() {
        super.viewDidLoad()
        tfComment.text = placeHolder
        tfComment.textColor = UIColor(named: colorNames.Placeholder)
        doneButtonOnKeyboard(textField: tfComment)
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension AddDiscussionCommentVC : UITextViewDelegate{

    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case tfComment:
            if tfComment.text == placeHolder{
                tfComment.text = ""
                tfComment.textColor = UIColor.black
            }
            break;
        default:
            break;
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case tfComment:
            if tfComment.text.isEmpty{
                tfComment.text = placeHolder
                tfComment.textColor = UIColor(named: colorNames.Placeholder)
            }
            break;
        default:
            break;
        }
    }

}
