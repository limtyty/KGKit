//
//  File.swift
//  
//
//  Created by Lim TyTy on 4/4/20.
//

import UIKit

public extension UITextField {
    enum ViewType {
        case left, right
    }
    
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
    
    
    // (1)
    func setView(_ type: ViewType, with view: UIView) {
        if type == ViewType.left {
            leftView = view
            leftViewMode = .always
        } else if type == .right {
            rightView = view
            rightViewMode = .always
        }
    }
    
    // Add Text to Left or Right View
    
    @discardableResult
    func setView(_ view: ViewType, title: String, space: CGFloat = 0) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: frame.height))
        button.setTitle(title, for: UIControl.State())
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: space, bottom: 4, right: space)
        button.sizeToFit()
        setView(view, with: button)
        return button
    }
    
    //Add Image to Left or right View
    @discardableResult
    func setView(_ view: ViewType, image: UIImage?, width: CGFloat = 50) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: frame.height))
        button.setImage(image, for: .normal)
        button.imageView!.contentMode = .scaleAspectFit
        //      button.tintColor = .gray
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        setView(view, with: button)
        return button
    }
    
    @discardableResult
    func setView(_ view: ViewType, space: CGFloat) -> UIView {
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: 1))
        setView(view, with: spaceView)
        return spaceView
    }
}
