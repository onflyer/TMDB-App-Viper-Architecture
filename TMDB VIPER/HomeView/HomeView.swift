//
//  HomeView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import SwiftUI

struct HomeView: View {
    
    @State var presenter: HomePresenter
    
    var body: some View {
        List {
            Section {
                ZStack {
                    ScrollView(.horizontal) {
                        
                    }
                    .scrollIndicators(.hidden)
                }
                .removeListRowFormatting()
            }
            header: {
                
            }
        }
        .navigationTitle("Welcome to TMDB")
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    return builder.homeView()
}
