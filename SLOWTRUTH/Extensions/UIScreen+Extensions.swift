//
//  UIScreen+Extensions.swift
//  SMARTOBD2
//
//  Created by Jules on 10/27/23.
//

import UIKit

extension UIScreen {
    static var current: UIScreen? {
        UIWindowScene.current?.screen
    }
}

extension UIWindowScene {
    static var current: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}
