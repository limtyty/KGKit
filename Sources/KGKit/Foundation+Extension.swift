//
//  File.swift
//  
//
//  Created by Lim TyTy on 3/23/20.
//

import Foundation

extension Double {

  func decimalFormater(symbol: String = "") -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) ?? ""
    return formattedNumber + " \(symbol)"
  }
}

extension Int{
  func decimalFormater(symbol: String = "") -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) ?? ""
    return formattedNumber + " \(symbol)"
  }
}
