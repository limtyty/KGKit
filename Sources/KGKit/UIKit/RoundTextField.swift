//
//  File 2.swift
//  
//
//  Created by Lim TyTy on 4/4/20.
//
import UIKit

open class RoundTextField: UITextField {
   
   override open func layoutSubviews() {
      super.layoutSubviews()
      borderStyle = .none
      layer.cornerRadius = 10
      layer.borderWidth = 0.1
      layer.borderColor = UIColor.gray.cgColor
      layer.shadowColor = UIColor.gray.cgColor
      layer.shadowOffset = CGSize(width: 0, height: 1.0)
      layer.shadowRadius = 3
      layer.masksToBounds = false
      layer.shadowOpacity = 0.6
      // set backgroundColor in order to cover the shadow inside the bounds
      layer.backgroundColor = UIColor.white.cgColor
   }
}
