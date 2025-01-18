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
            popularSection
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .background(Color(uiColor: .secondarySystemBackground))
        .navigationTitle("Welcome to TMDB")
        .searchable(text: $presenter.query,placement: .navigationBarDrawer(displayMode: .always), prompt: "Search movies") {
            searchableSection
        }
        .task {
            await presenter.loadNowPlayingMovies()
        }
        .task {
            await presenter.loadUpcomingMovies()
        }
        .task {
            await presenter.loadTopRatedMovies()
        }
        .task{
            await presenter.loadPopularMovies()
        }
        .task(id: presenter.query) {
            await presenter.loadSearchedMovies()
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
                                .task {
                                    await presenter.loadMoreNowPlayingMovies(currentItem: movie)
                                }
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
                                .task {
                                    await presenter.loadMoreUpcomingMovies(currentItem: movie)
                                }
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
                                .task {
                                    await presenter.loadMoreTopRatedMovies(currentItem: movie)
                                }
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
    
    var popularSection: some View {
        Section {
            ZStack {
                ScrollView(.horizontal) {
                    LazyHStack (spacing: 15) {
                        ForEach(presenter.popularMovies) { movie in
                            MovieCellView(title: movie.title ?? "N/A", imageName: movie.posterURLString)
                                .anyButton {
                                    presenter.onMoviePressed(id: movie.id)
                                }
                                .shadow(color: .secondary, radius: 3)
                                .frame(width: 300)
                                .task {
                                    await presenter.loadMorePopularMovies(currentItem: movie)
                                }
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
            Text("Popular")
        }
    }

    
    var searchableSection: some View {
        ForEach(presenter.searchedMovies) { movie in
            SearchCellView(posterUrlString: movie.posterURLString, title: movie.title ?? "No title", releaseDate: movie.releaseDate ?? "No release date", ratingText: movie.ratingText ?? "No rating")
                .anyButton {
                    presenter.onMoviePressed(id: movie.id)
                }
        }
        .listStyle(.plain)
    }
}

#Preview("Dev preview") {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    return builder.homeView()
}
