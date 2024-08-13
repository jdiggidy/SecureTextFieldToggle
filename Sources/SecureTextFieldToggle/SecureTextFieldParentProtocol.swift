//
//  SecureTextFieldParentProtocol.swift
//
//
//  Created by Jeremy Barger on 6/25/24.
//

import Foundation


/// Protocol method for SecureTextFieldToggle
protocol SecureTextFieldParentProtocol {
    
    /// When conforming to this protocol, you must call `hideKeyboard()`
    
    var hideKeyboard: (() -> Void)? {get set}
    
}
