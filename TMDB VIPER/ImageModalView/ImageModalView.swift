//
//  ImageModalView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 26. 1. 2025..
//

import SwiftUI

struct ImageModalViewDelegate {
    var urlString: String = Constants.randomImage
    var onDismiss: () -> Void = {}
}

struct ImageModalView: View {
    let delegate: ImageModalViewDelegate
    
    var body: some View {
        // Image with poster aspect ratio (2:3)
        ImageLoaderView(urlString: delegate.urlString, resizingMode: .fit)
            .aspectRatio(2/3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.5), radius: 20)
            .padding(.horizontal, 20)
            .overlay(alignment: .topTrailing) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(radius: 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        delegate.onDismiss()
                    }
                    .offset(x: -25, y: -35)
            }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.7)
            .ignoresSafeArea()
        ImageModalView(delegate: ImageModalViewDelegate(urlString: "https://image.tmdb.org/t/p/w500/t5zCBSB5xMDKcDqe91qahCOUYVV.jpg"))
    }
}
