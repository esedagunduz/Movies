//
//  UIViewExtensions.swift
//  NewMovie
//
//  Created by ebrar seda gündüz on 29.07.2024.
//

import Foundation
import Foundation
import UIKit
extension UIView{
    func round(_ radius:CGFloat = 10){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    func addBorder(color:UIColor , width:CGFloat){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
