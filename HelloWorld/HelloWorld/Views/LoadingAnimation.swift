//
//  LoadingAnimation.swift
//  HelloWorld
//
//  Created by Larry N on 11/6/20.
//

import SwiftUI

struct LoadingAnimation : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<LoadingAnimation>) -> UIActivityIndicatorView {
        
        let loadingAnimation = UIActivityIndicatorView(style: .large)
        loadingAnimation.startAnimating()
        return loadingAnimation
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingAnimation>) {
    }
}

struct LoadingAnimation_Previews: PreviewProvider {
    static var previews: some View {
        LoadingAnimation()
    }
}
