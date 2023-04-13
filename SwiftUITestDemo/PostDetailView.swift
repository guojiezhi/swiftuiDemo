//
//  PostDetailView.swift
//  SwiftUITestDemo
//
//  Created by 郭杰智 on 2023/4/6.
//

import SwiftUI
import BBSwiftUIKit

struct PostDetailView: View {
    let post: Post
    
    var body: some View {
        BBTableView(0...10) { i in
            if i == 0 {
                PostCell(post: self.post)
            } else {
                HStack {
                    Text("评论\(i)").padding()
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("详情", displayMode: .inline)
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData.testData
        return PostDetailView(post: userData.recommendPostList.list[0]).environmentObject(userData)
    }
}
