//
//  SearchView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 2. 1. 2025..
//

import SwiftUI

struct SearchViewDelegate {
    
}

struct SearchView: View {
    @State var presenter: SearchPresenter
    var delegate: SearchViewDelegate
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
}
