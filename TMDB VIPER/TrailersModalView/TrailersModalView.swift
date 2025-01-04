//
//  TrailersModalView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 4. 1. 2025..
//

import SwiftUI

struct TrailersModalDelegate {
    var movie: SingleMovie = .mock()
}

struct TrailersModalView: View {
    let delegate: TrailersModalDelegate
    
    var body: some View {
        List {
            ForEach(delegate.movie.videos?.results ?? [] ) { trailer in
                Link(destination: trailer.youtubeURL!, label: {
                    HStack {
                        Text(trailer.name ?? "N/A")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "play.circle.fill")
                    }
                })
                .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    TrailersModalView(delegate: TrailersModalDelegate())
}
