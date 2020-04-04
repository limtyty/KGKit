//
//  UIKit+Extension.swift
//  KGKit
//
//  Created by Lim TyTy on 3/23/20.
//  Copyright © 2020 Lim TyTy. All rights reserved.
//
import UIKit

// MARK: UICOLOR

public extension UIColor{
   convenience init(hex: String, alpha: CGFloat = 1.0) {
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

public extension UIView {
   
   func roundView(radius: CGFloat = 0.0,borderWidth: Int = 0,borderColor: UIColor = .white) {
      layoutIfNeeded()
      let size = self.frame.height >= self.frame.width ? self.frame.width : self.frame.height
      radius != 0 ? (layer.cornerRadius = size / 2) :  (layer.cornerRadius = radius)
      layer.borderWidth = 2
      layer.borderColor = borderColor.cgColor
   }
   
   func setGradientColor(startColor:CGColor,endColor:CGColor){
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

public extension UICollectionView {
   func register<T: UICollectionViewCell>(_: T.Type){
      register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
   }
   
   func registerNib<T: UICollectionViewCell>(_: T.Type){
      let bundle = Bundle(for: T.self)
      let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
      register(nib, forCellWithReuseIdentifier: String(describing: T.self))
   }
   
   func register<T: UICollectionReusableView>(_: T.Type, supplementaryViewOfKind: String){
      register(T.self, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: String(describing: T.self))
   }
   
   func registerNib<T: UICollectionReusableView>(_: T.Type, supplementaryViewOfKind: String){
      let bundle = Bundle(for: T.self)
      let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
      register(nib, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: String(describing: T.self))
   }
   
   //Dequeue methods for UICollectionView
   func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T{
      guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
         fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
      }
      return cell
   }
   
   func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String, indexPath: IndexPath) -> T{
      guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
         fatalError("Could not dequeue supplementary view with identifier: \(String(describing: T.self))")
      }
      return supplementaryView
   }
}


// MARK: UITableView

// MARK: - Properties
public extension UITableView {

    /// SwifterSwift: Index path of last row in tableView.
    var indexPathForLastRow: IndexPath? {
        guard let lastSection = lastSection else { return nil }
        return indexPathForLastRow(inSection: lastSection)
    }

    /// SwifterSwift: Index of last section in tableView.
    var lastSection: Int? {
        return numberOfSections > 0 ? numberOfSections - 1 : nil
    }

}

// MARK: - Methods
public extension UITableView {
   
   /// SwifterSwift: Number of all rows in all sections of tableView.
   ///
   /// - Returns: The count of all rows in the tableView.
   func numberOfRows() -> Int {
       var section = 0
       var rowCount = 0
       while section < numberOfSections {
           rowCount += numberOfRows(inSection: section)
           section += 1
       }
       return rowCount
   }

   /// SwifterSwift: IndexPath for last row in section.
   ///
   /// - Parameter section: section to get last row in.
   /// - Returns: optional last indexPath for last row in section (if applicable).
   func indexPathForLastRow(inSection section: Int) -> IndexPath? {
       guard numberOfSections > 0, section >= 0 else { return nil }
       guard numberOfRows(inSection: section) > 0  else {
           return IndexPath(row: 0, section: section)
       }
       return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
   }

   /// SwifterSwift: Reload data with a completion handler.
   ///
   /// - Parameter completion: completion handler to run after reloadData finishes.
   func reloadData(_ completion: @escaping () -> Void) {
       UIView.animate(withDuration: 0, animations: {
           self.reloadData()
       }, completion: { _ in
           completion()
       })
   }

   /// SwifterSwift: Remove TableFooterView.
   func removeTableFooterView() {
       tableFooterView = nil
   }

   /// SwifterSwift: Remove TableHeaderView.
   func removeTableHeaderView() {
       tableHeaderView = nil
   }

   /// SwifterSwift: Scroll to bottom of TableView.
   ///
   /// - Parameter animated: set true to animate scroll (default is true).
   func scrollToBottom(animated: Bool = true) {
       let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
       setContentOffset(bottomOffset, animated: animated)
   }

   /// SwifterSwift: Scroll to top of TableView.
   ///
   /// - Parameter animated: set true to animate scroll (default is true).
   func scrollToTop(animated: Bool = true) {
       setContentOffset(CGPoint.zero, animated: animated)
   }
   
   /// SwifterSwift: Check whether IndexPath is valid within the tableView
   ///
   /// - Parameter indexPath: An IndexPath to check
   /// - Returns: Boolean value for valid or invalid IndexPath
   func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
       return indexPath.section >= 0 &&
           indexPath.row >= 0 &&
           indexPath.section < numberOfSections &&
           indexPath.row < numberOfRows(inSection: indexPath.section)
   }

   /// SwifterSwift: Safely scroll to possibly invalid IndexPath
   ///
   /// - Parameters:
   ///   - indexPath: Target IndexPath to scroll to
   ///   - scrollPosition: Scroll position
   ///   - animated: Whether to animate or not
   func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
       guard indexPath.section < numberOfSections else { return }
       guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return }
       scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
   }
   
   //Registering Cell
   func register<T: UITableViewCell>(_: T.Type){
      register(T.self, forCellReuseIdentifier: String(describing: T.self))
   }
   
   func registerNib<T: UITableViewCell>(_: T.Type){
      let bundle = Bundle(for: T.self)
      let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
      register(nib, forCellReuseIdentifier: String(describing: T.self))
   }
   
   //Registering HeaderFooterView
   
   func register<T: UITableViewHeaderFooterView>(_: T.Type){
      register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
   }
   
   func registerNib<T: UITableViewHeaderFooterView>(_: T.Type){
      let bundle = Bundle(for: T.self)
      let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
      register(nib, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
   }
   
   //Dequeue methods for UITableView
   
   func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T{
      guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
         fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
      }
      return cell
   }
   
   func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ : T.Type) -> T{
      guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
         fatalError("Could not dequeue Header/Footer with identifier: \(String(describing: T.self))")
      }
      return headerFooter
   }
   
   func dequeueCell(reuseIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
      return dequeueReusableCell(
         withIdentifier: identifier,
         for: indexPath
      )
   }
   
}

