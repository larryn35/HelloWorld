//
//  LoadingAnimation.swift
//  HelloWorld
//
//  Created by Larry N on 11/6/20.
//

import SwiftUI

struct Loading: View {
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .fill(Color.black.opacity(0.3))
        .frame(width: 75, height: 75)
            
      LoadingAnimation()
    }
  }
}

struct LoadingAnimation : UIViewRepresentable {
  
  func makeUIView(context: UIViewRepresentableContext<LoadingAnimation>) -> UIActivityIndicatorView {
    let loadingAnimation = UIActivityIndicatorView(style: .large)
    loadingAnimation.startAnimating()
    return loadingAnimation
  }
  
  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingAnimation>) {
  }
}
