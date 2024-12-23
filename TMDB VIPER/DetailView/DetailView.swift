//
//  DetailView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import SwiftUI

struct DetailViewDelegate {
    var movieId: Int
}

struct DetailView: View {
    
    @State var presenter: DetailPresenter

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    RouterView { router in
        builder.detailView(router: router)
    }
}
