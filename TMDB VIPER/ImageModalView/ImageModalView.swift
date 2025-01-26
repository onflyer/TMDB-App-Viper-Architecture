//
//  ImageModalView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 26. 1. 2025..
//

import SwiftUI

struct ImageModalViewDelegate {
    var urlString:String = Constants.randomImage
}

struct ImageModalView: View {
    let delegate: ImageModalViewDelegate
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
            ImageLoaderView(urlString: delegate.urlString)
                .scaledToFit()
        }
        
    }
}

#Preview {
    ImageModalView(delegate: ImageModalViewDelegate(urlString: Constants.randomImage))
}
