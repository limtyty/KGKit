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

public protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

public protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

// MARK: UICollectionView

extension UICollectionView {
    public func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    public func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
   
   public func register<T: UICollectionReusableView>(_: T.Type, supplementaryViewOfKind: String) where T: ReusableView {
       register(T.self, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: T.defaultReuseIdentifier)
   }
   
   public func register<T: UICollectionReusableView>(_: T.Type, supplementaryViewOfKind: String) where T: ReusableView, T: NibLoadableView {
       let bundle = Bundle(for: T.self)
       let nib = UINib(nibName: T.nibName, bundle: bundle)
       register(nib, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: T.defaultReuseIdentifier)
   }
   
   //Dequeue methods for UICollectionView
   public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
       guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
           fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
       }
       return cell
   }

   public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String, indexPath: IndexPath) -> T where T: ReusableView {
       guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
           fatalError("Could not dequeue supplementary view with identifier: \(T.defaultReuseIdentifier)")
       }
       return supplementaryView
   }
}


// MARK: UITableView
extension UITableView {
   
   //Registering Cell
   public func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
       register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
   }
   
   public func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
       let bundle = Bundle(for: T.self)
       let nib = UINib(nibName: T.nibName, bundle: bundle)
       register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
   }
   
   //Registering HeaderFooterView
   
   public func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableView {
       register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
   }
   
   public func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableView, T: NibLoadableView {
       let bundle = Bundle(for: T.self)
       let nib = UINib(nibName: T.nibName, bundle: bundle)
       register(nib, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
   }
   
   //Dequeue methods for UITableView
  
   public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
       guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
           fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
       }
       return cell
   }

   public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ : T.Type) -> T where T: ReusableView {
       guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
           fatalError("Could not dequeue Header/Footer with identifier: \(T.defaultReuseIdentifier)")
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
