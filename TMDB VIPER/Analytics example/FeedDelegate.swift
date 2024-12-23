////
////  FeedDelegate.swift
////  TMDB VIPER
////
////  Created by Aleksandar Milidrag on 23. 12. 2024..
////
//
//
//import SwiftUI
//
//struct FeedDelegate {
//    var eventParameters: [String: Any]? {
//        nil
//    }
//}
//
//struct FeedView: View {
//    
//    @State var presenter: FeedPresenter
//    let delegate: FeedDelegate
//    
//    var body: some View {
//        Text("Hello, World!")
//            .onAppear {
//                presenter.onViewAppear(delegate: delegate)
//            }
//            .onDisappear {
//                presenter.onViewDisappear(delegate: delegate)
//            }
//    }
//}
//
//#Preview {
//    let container = DevPreview.shared.container()
//    let interactor = CoreInteractor(container: container)
//    let builder = CoreBuilder(interactor: interactor)
//    let delegate = FeedDelegate()
//    
//    return RouterView { router in
//        builder.feedView(router: router, delegate: delegate)
//    }
//}
//
//extension CoreBuilder {
//    
//    func feedView(router: AnyRouter, delegate: FeedDelegate = FeedDelegate()) -> some View {
//        FeedView(
//            presenter: FeedPresenter(
//                interactor: interactor,
//                router: CoreRouter(router: router, builder: self)
//            ),
//            delegate: delegate
//        )
//    }
//    
//}
//
//extension CoreRouter {
//    
//    func showFeedView(delegate: FeedDelegate = FeedDelegate()) {
//        router.showScreen(.push) { router in
//            builder.feedView(router: router, delegate: delegate)
//        }
//    }
//    
//}
