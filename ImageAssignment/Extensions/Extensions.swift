//
//  Extensions.swift
//  ImageAssignment
//
//  Created by Vikas sharma on 21/02/21.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(title: String,msg: String,alertButtons listOfAlertButtons: [UIAlertAction]?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        if let listOfActionButtons = listOfAlertButtons {
            for currentAlert in listOfActionButtons {
                alert.addAction(currentAlert)
            }
        }else {
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
}
