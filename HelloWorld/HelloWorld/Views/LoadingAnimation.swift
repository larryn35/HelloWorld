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
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(.gray)
                .opacity(0.5)
                .frame(width: 75, height: 75)
            
            LoadingAnimation()

            }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
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

//struct LoadingAnimation_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingAnimation()
//    }
//}
