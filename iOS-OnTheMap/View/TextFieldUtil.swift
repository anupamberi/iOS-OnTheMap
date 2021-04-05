//
//  TextFieldExtension.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 05/04/2021.
//

import UIKit

// MARK : Contains utility methods that are reused among different UITextFields

extension UITextField {
    
    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
