//
//  HomePagePlaceholder.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 18. 1. 2025..
//

import SwiftUI

struct HomePagePlaceholder: View {
    @State var width: CGFloat = .zero
    @State var height: CGFloat = .zero
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(0..<4) { placeholder in
                        ShimmerLoadingView()
                }
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

#Preview {
    HomePagePlaceholder(width: 170, height: 240)
        
    
}
