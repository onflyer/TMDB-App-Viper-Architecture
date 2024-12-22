//
//  SegueOption.swift
//  ArchitectureBootcamp
//
//  Created by Nick Sarno on 11/15/24.
//


enum SegueOption {
    case push, sheet, fullScreenCover
    
    var shouldAddNewNavigationView: Bool {
        switch self {
        case .push:
            return false
        case .sheet, .fullScreenCover:
            return true
        }
    }
}