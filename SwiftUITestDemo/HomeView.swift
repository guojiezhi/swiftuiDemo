//
//  HomeView.swift
//  SwiftUITestDemo
//
//  Created by 郭杰智 on 2023/4/6.
//

import SwiftUI
struct HomeView: View {
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                        PostListView(category: .recommend)
                            .frame(width: geometry.size.width)
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("首页", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
