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

// MARK: UICollectionView

extension UICollectionView {
    public func register<T: UICollectionViewCell>(_: T.Type){
      register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    public func registerNib<T: UICollectionViewCell>(_: T.Type){
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
        register(nib, forCellWithReuseIdentifier: String(describing: T.self))
    }
   
   public func register<T: UICollectionReusableView>(_: T.Type, supplementaryViewOfKind: String){
       register(T.self, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: String(describing: T.self))
   }
   
   public func registerNib<T: UICollectionReusableView>(_: T.Type, supplementaryViewOfKind: String){
       let bundle = Bundle(for: T.self)
       let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
       register(nib, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: String(describing: T.self))
   }
   
   //Dequeue methods for UICollectionView
   public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T{
       guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
           fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
       }
       return cell
   }

   public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String, indexPath: IndexPath) -> T{
       guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
           fatalError("Could not dequeue supplementary view with identifier: \(String(describing: T.self))")
       }
       return supplementaryView
   }
}


// MARK: UITableView
extension UITableView {
   
   //Registering Cell
   public func register<T: UITableViewCell>(_: T.Type){
       register(T.self, forCellReuseIdentifier: String(describing: T.self))
   }
   
   public func registerNib<T: UITableViewCell>(_: T.Type){
       let bundle = Bundle(for: T.self)
       let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
       register(nib, forCellReuseIdentifier: String(describing: T.self))
   }
   
   //Registering HeaderFooterView
   
   public func register<T: UITableViewHeaderFooterView>(_: T.Type){
       register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
   }
   
   public func registerNib<T: UITableViewHeaderFooterView>(_: T.Type){
       let bundle = Bundle(for: T.self)
       let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
       register(nib, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
   }
   
   //Dequeue methods for UITableView
  
   public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T{
       guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
           fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
       }
       return cell
   }

   public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ : T.Type) -> T{
       guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
           fatalError("Could not dequeue Header/Footer with identifier: \(String(describing: T.self))")
       }
       return headerFooter
   }
  
   public func dequeueCell(reuseIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
      return dequeueReusableCell(
         withIdentifier: identifier,
         for: indexPath
      )
   }
   
}
