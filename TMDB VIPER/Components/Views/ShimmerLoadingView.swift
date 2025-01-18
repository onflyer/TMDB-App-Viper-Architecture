//
//  ShimmerLoadingView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 18. 1. 2025..
//

import SwiftUI

struct ShimmerLoadingView: View {
    
    private var gradientColors = [
        Color(uiColor: .systemGray3),
        Color(uiColor: .systemGray6),
        Color(uiColor: .systemGray3)
    ]
    
    @State var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State var endPoint: UnitPoint = .init(x: 0, y: -0.2)

    var body: some View {
        LinearGradient(colors: gradientColors, startPoint: startPoint, endPoint: endPoint)
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                    startPoint = .init(x: 1, y: 1)
                    endPoint = .init(x: 2.2, y: 2.2)
                    
                    
                }
            }
    }
}

#Preview {
    ShimmerLoadingView()
}
