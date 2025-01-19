//
//  Error + EXT.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 19. 1. 2025.
//

import Foundation

extension Error {
    
    var eventParameters: [String: Any] {
        [
            "error_description": localizedDescription
        ]
    }
}
