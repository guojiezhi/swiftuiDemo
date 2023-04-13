//
//  OriginalButtonStyle.swift
//  SwiftUITestDemo
//
//  Created by 郭杰智 on 2023/4/6.
//

import SwiftUI

struct OriginalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
