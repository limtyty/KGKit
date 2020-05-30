//
//  File.swift
//  
//
//  Created by Lim TyTy on 4/10/20.
//

import UIKit

public extension NSAttributedString{
   
   static func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {

       /// Usage NSRange : NSMakeRange(loc,len)
       let fontSize = UIFont.systemFontSize
       let attrs = [
           NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
           NSAttributedString.Key.foregroundColor: UIColor.black
       ]
       let nonBoldAttribute = [
           NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
       ]
       let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
       if let range = nonBoldRange {
           attrStr.setAttributes(nonBoldAttribute, range: range)
       }
       return attrStr
   }
   
   static func attributeString(boldText: String , regularText: String) -> NSAttributedString{
      let boldAttribute = [
         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
      ]
      let regularAttribute = [
         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)
      ]
      let boldText = NSAttributedString(string: boldText, attributes: boldAttribute)
      let regularText = NSAttributedString(string: regularText, attributes: regularAttribute)
      
      let newString = NSMutableAttributedString()
      newString.append(boldText)
      newString.append(regularText)
      return newString
   }
   
}
