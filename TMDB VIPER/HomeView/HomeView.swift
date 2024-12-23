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
                        LazyHStack (spacing: 15) {
                            ForEach(0..<10) { movie in
                                MovieCellView(title: "")
                                    .frame(width: 170, height: 240)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .scrollIndicators(.hidden)
                }
                .listSectionSeparator(.hidden)
                .removeListRowFormatting()
            }
            header: {
                Text("Now playing")
            }
        }
        .listStyle(.plain)
        .navigationTitle("Welcome to TMDB")
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    return builder.homeView()
}
