//
//  ImageLoaderView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//


import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {
    
    var urlString: String = "ss"
    var resizingMode: ContentMode = .fill
    var forceTransitionAnimation: Bool = false
    
    var body: some View {
        Rectangle()
            .opacity(0.13)
            .overlay(
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            )
            .clipped()
            .ifSatisfiedCondition(forceTransitionAnimation) { content in
                content
                    .drawingGroup()
            }
    }
}

#Preview {
    ImageLoaderView()
        .frame(width: 200, height: 200)
        .anyButton(.highlight) {
            
        }
}
