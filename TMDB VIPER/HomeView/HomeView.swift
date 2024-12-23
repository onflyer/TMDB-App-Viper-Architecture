//
//  HomeView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import SwiftUI

struct HomeView: View {
    
    @State var presenter: HomePresenter
    @State var isLoading: Bool = false
    
    var body: some View {
        List {
            Section {
                ZStack {
                    ScrollView(.horizontal) {
                        LazyHStack (spacing: 15) {
                            ForEach(0..<10) { movie in
                                MovieCellView(title: "")
                                    .anyButton {
                                        
                                    }
                                    .shadow(color: .secondary, radius: 3)
                                    .frame(width: 170, height: 240)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
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
        .background(Color(uiColor: .secondarySystemBackground))
        .listStyle(.plain)
        .navigationTitle("Welcome to TMDB")
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    return builder.homeView()
}
