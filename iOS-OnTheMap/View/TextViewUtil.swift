//
//  SignUpTextView.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 03/04/2021.
//

import UIKit

extension UITextView {
    
    // MARK: Reference https://stackoverflow.com/questions/39238366/uitextview-with-hyperlink-text
    
    func addHyperlink(originalText: String, hyperLink: String, urlString: String) {
        let style = NSMutableParagraphStyle()
        
        style.alignment = .center

        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: fullRange)

        self.linkTextAttributes = [
            kCTForegroundColorAttributeName: UIColor.blue,
            kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue,
        ] as [NSAttributedString.Key : Any]

        self.attributedText = attributedOriginalText
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 18)
    }
}

