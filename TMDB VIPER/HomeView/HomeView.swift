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
            nowPlayingSection
            upcomingSection
            topRatedSection
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .background(Color(uiColor: .secondarySystemBackground))
        .navigationTitle("Welcome to TMDB")
        .task {
            await presenter.loadNowPlayingMovies()
        }
        .task {
            await presenter.loadUpcomingMovies()
        }
        .task {
            await presenter.loadTopRatedMovies()
        }
    }
}

extension HomeView {
    var nowPlayingSection: some View {
        Section {
            ZStack {
                ScrollView(.horizontal) {
                    LazyHStack (spacing: 15) {
                        ForEach(presenter.nowPlayingMovies) { movie in
                            MovieCellView(title: "", imageName: movie.posterURLString)
                                .anyButton {
                                    presenter.onMoviePressed(id: movie.id)
                                }
                                .shadow(color: .secondary, radius: 3)
                                .frame(width: 170)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }
                .frame(height: 240)
                .scrollIndicators(.hidden)
            }
            .listSectionSeparator(.hidden)
            .removeListRowFormatting()
        }
        header: {
            Text("Now playing")
        }
        
    }
    
    var upcomingSection: some View {
        Section {
            ZStack {
                ScrollView(.horizontal) {
                    LazyHStack (spacing: 15) {
                        ForEach(presenter.upcomingMovies) { movie in
                            MovieCellView(title: movie.title ?? "N/A", imageName: movie.posterURLString)
                                .anyButton {
                                    presenter.onMoviePressed(id: movie.id)
                                }
                                .shadow(color: .secondary, radius: 3)
                                .frame(width: 300)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }
                .frame(height: 150)
                .scrollIndicators(.hidden)
            }
            .listSectionSeparator(.hidden)
            .removeListRowFormatting()
        }
        header: {
            Text("Upcoming")
        }
    }
    
    var topRatedSection: some View {
        Section {
            ZStack {
                ScrollView(.horizontal) {
                    LazyHStack (spacing: 15) {
                        ForEach(presenter.topRatedMovies) { movie in
                            MovieCellView(title: "", imageName: movie.posterURLString)
                                .anyButton {
                                    presenter.onMoviePressed(id: movie.id)
                                }
                                .shadow(color: .secondary, radius: 3)
                                .frame(width: 170)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }
                .frame(height: 240)
                .scrollIndicators(.hidden)
            }
            .listSectionSeparator(.hidden)
            .removeListRowFormatting()
        }
        header: {
            Text("Top rated")
        }
        
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    return builder.homeView()
}
