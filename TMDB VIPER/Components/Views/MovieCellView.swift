//
//  MovieCellView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import SwiftUI

struct MovieCellView: View {
    
    var title: String = "Title"
    var font: Font = .title2
    var imageName: String = Constants.randomImage
    var cornerRadius: CGFloat = 8
    
    var body: some View {
        ImageLoaderView(urlString: imageName)
            .overlay(alignment: .bottomLeading, content: {
                Text(title)
                    .font(font)
                    .fontWeight(.semibold)
                    .padding(16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .addingGradientBackgroundForText()
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
            })
            .cornerRadius(cornerRadius)
    }
}

#Preview("Poster") {
    MovieCellView()
        .frame(width: 180, height: 280)
}

#Preview("Backdrop") {
    MovieCellView()
        .frame(height: 170)
}
