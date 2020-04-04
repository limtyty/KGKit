//
//  File.swift
//  
//
//  Created by Lim TyTy on 4/4/20.
//

import UIKit

public extension UITextField {
   func setLeftIcon(_ image: UIImage,tintColor: UIColor) {
      let iconView = UIImageView(frame:
         CGRect(x: 10, y: 5, width: 20, height: 20))
      iconView.contentMode = .scaleAspectFit
      iconView.image = image
      iconView.tintColor = tintColor
      let iconContainerView: UIView = UIView(frame:
         CGRect(x: 20, y: 0, width: 30, height: 30))
      iconContainerView.addSubview(iconView)
      leftView = iconContainerView
      leftViewMode = .always
   }
}
