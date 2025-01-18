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
                    
                    ZStack {
                        ShimmerLoadingView()
                    }
                    .frame(width: width, height: height)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    HomePagePlaceholder()
}
