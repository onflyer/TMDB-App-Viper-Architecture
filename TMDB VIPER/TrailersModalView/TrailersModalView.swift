//
//  TrailersModalView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 4. 1. 2025..
//

import SwiftUI

struct TrailersModalDelegate {
    var movie: SingleMovie = .mock()
    var onDismiss: () -> Void = {}
}

struct TrailersModalView: View {
    let delegate: TrailersModalDelegate
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(systemName: "xmark.circle.fill")
                    .tappableBackground()
                    .anyButton {
                        delegate.onDismiss()
                    }
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background(Color(uiColor: .secondarySystemBackground))
            ScrollView {
                VStack {
                    ForEach(delegate.movie.videos?.results ?? [] ) { trailer in
                        Link(destination: trailer.youtubeURL!, label: {
                            HStack {
                                Text(trailer.name ?? "N/A")
                                
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: "play.circle.fill")
                            }
                        })
                        .padding(.horizontal)
                        Divider()
                        
                    }
                }
                
            }
            .background(Color(uiColor: .secondarySystemBackground))

        }
        .foregroundColor(.tmdb)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.vertical ,150)
        .padding(.horizontal, 50)
        
        
        
    }
}

#Preview {
    TrailersModalView(delegate: TrailersModalDelegate())
}
