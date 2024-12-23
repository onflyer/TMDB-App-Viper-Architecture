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
//        .aspectRatio(9/16, contentMode: .fit)
        .frame(width: 200, height: 300)
}

#Preview("Backdrop") {
    MovieCellView()
//        .aspectRatio(16/9, contentMode: .fit)
        .frame(height: 170)
}
