//
//  UIKit+Extension.swift
//  KGKit
//
//  Created by Lim TyTy on 3/23/20.
//  Copyright © 2020 Lim TyTy. All rights reserved.
//

import UIKit

// MARK: UICOLOR

extension UIColor{
  public convenience init(hex: String, alpha: CGFloat = 1.0) {
    var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    
    if hexFormatted.hasPrefix("#") {
      hexFormatted = String(hexFormatted.dropFirst())
    }
    assert(hexFormatted.count == 6, "Invalid hex code used.")
    
    var rgbValue: UInt64 = 0
    Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
    
    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
  }
}

// MARK: UIVIEW

extension UIView {
  
  public func roundView(radius: CGFloat = 0.0,borderWidth: Int = 0,borderColor: UIColor = .white) {
    layoutIfNeeded()
    let size = self.frame.height >= self.frame.width ? self.frame.width : self.frame.height
    radius != 0 ? (layer.cornerRadius = size / 2) :  (layer.cornerRadius = radius)
    layer.borderWidth = 2
    layer.borderColor = borderColor.cgColor
  }
  
  public func setGradientColor(startColor:CGColor,endColor:CGColor){
    if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
      gradientLayer.colors = [startColor, endColor]
    }else {
      let gradientLayer = CAGradientLayer()
      gradientLayer.frame = self.bounds
      gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
      gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
      gradientLayer.colors = [startColor, endColor]
      self.layer.insertSublayer(gradientLayer, at: 0)
    }
  }
}

// MARK: UITableView
extension UITableView {
  
   func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
      self.register(T.self, forCellReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
   }
  
   func dequeue<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
      guard
         let cell = dequeueReusableCell(withIdentifier: String(describing: T.self),
                                        for: indexPath) as? T
         else { fatalError("Could not deque cell with type \(T.self)") }
      
      return cell
   }
  
   func dequeueCell(reuseIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
      return dequeueReusableCell(
         withIdentifier: identifier,
         for: indexPath
      )
   }
   
}
