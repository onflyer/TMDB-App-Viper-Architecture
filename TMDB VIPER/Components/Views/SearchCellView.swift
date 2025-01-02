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
        HStack(alignment: .center, spacing: 16) {
            ImageLoaderView(urlString: posterUrlString, resizingMode: .fit, forceTransitionAnimation: false)
                .frame(width: 60, height: 90)
                .cornerRadius(8)
                .shadow(radius: 3)
            
            VStack(alignment: .leading) {
                Text(title)
                .font(.headline)
                
                Text(releaseDate)
                .font(.subheadline)
                
                Text(ratingText)
                .foregroundColor(.yellow)
            }
        }
        
    }
}

#Preview {
    SearchCellView(posterUrlString: Movie.mocks().first?.posterPath ?? "No image", title: Movie.mocks().first?.title ?? "No title", releaseDate: Movie.mocks().first?.releaseDateForrmated ?? "No release date", ratingText: Movie.mocks().first?.ratingText ?? "No rating")
}
