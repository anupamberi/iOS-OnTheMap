//
//  TextFieldExtension.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 05/04/2021.
//

import UIKit

extension UITextField {
    
    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
