//
//  Binding+EXT.swift
//  ArchitectureBootcamp
//
//  Created by Nick Sarno on 11/15/24.
//
import SwiftUI

extension Binding where Value == Bool {
    
    init<T: Sendable>(ifNotNil value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}
