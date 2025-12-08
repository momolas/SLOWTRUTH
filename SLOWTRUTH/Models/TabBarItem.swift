//
//  TabBarItem.swift
//  SLOWTRUTH
//
//  Created by kemo konteh on 10/5/23.
//

import SwiftUI

enum TabBarItem: Hashable {
    case dashBoard
    case diagnostic
    case history
    case settings

    var iconName: String {
        switch self {
        case .dashBoard:
            return "square.grid.2x2.fill"
        case .diagnostic:
            return "wrench.and.screwdriver.fill"
        case .history:
            return "clock.arrow.circlepath"
        case .settings:
            return "gearshape.fill"
        }
    }

    var title: String {
        switch self {
        case .dashBoard:
            return "Tableau de bord"
        case .diagnostic:
            return "Diagnostic"
        case .history:
            return "Historique"
        case .settings:
            return "Paramètres"
        }
    }

    var color: Color {
        switch self {
        case .dashBoard:
            return Color.blue
        case .diagnostic:
            return Color.blue
        case .history:
            return Color.blue
        case .settings:
            return Color.blue
        }
    }
}
