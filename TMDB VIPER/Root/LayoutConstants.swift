//
//  LayoutConstants.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 4. 1. 2026..
//

import UIKit

// MARK: - Layout Constants
/// Centralized constants for consistent spacing and sizing throughout the app.
/// This eliminates magic numbers and ensures design consistency.

enum LayoutConstants {
    
    // MARK: - Poster Sizes
    enum Poster {
        static let width: CGFloat = 150
        static let height: CGFloat = 225
        
        // Smaller poster for cells
        enum Small {
            static let width: CGFloat = 60
            static let height: CGFloat = 90
        }
        
        // Detail view poster
        enum Detail {
            static let width: CGFloat = 120
            static let height: CGFloat = 180
        }
    }
    
    // MARK: - Backdrop Sizes
    enum Backdrop {
        static let width: CGFloat = 300
        static let height: CGFloat = 170
        
        // Detail view backdrop
        enum Detail {
            static let height: CGFloat = 220
        }
    }
    
    // MARK: - Spacing
    enum Spacing {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let standard: CGFloat = 16
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    enum CornerRadius {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 12
        static let extraLarge: CGFloat = 16
    }
    
    // MARK: - Cell Heights
    enum CellHeight {
        static let searchResult: CGFloat = 100
        static let favorite: CGFloat = 100
    }
    
    // MARK: - Section Header
    enum SectionHeader {
        static let height: CGFloat = 44
    }
    
    // MARK: - Button Sizes
    enum Button {
        static let standard: CGFloat = 44
        static let large: CGFloat = 50
    }
}
