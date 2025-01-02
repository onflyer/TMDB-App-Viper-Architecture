//
//  SearchCellView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 2. 1. 2025..
//

import SwiftUI

struct SearchCellView: View {
    var posterUrlString: String
    var title: String
    var releaseDate: String
    var ratingText: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ImageLoaderView(urlString: posterUrlString, resizingMode: .fit, forceTransitionAnimation: false)
                .scaledToFit()
                
        }
        
    }
}

#Preview {
    SearchCellView(posterUrlString: Movie.mocks().first?.posterPath ?? "No image", title: Movie.mocks().first?.title ?? "No title", releaseDate: Movie.mocks().first?.releaseDateForrmated ?? "No release date", ratingText: Movie.mocks().first?.ratingText ?? "No rating")
}
