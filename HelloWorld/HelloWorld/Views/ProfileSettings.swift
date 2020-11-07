//
//  ProfileSettings.swift
//  HelloWorld
//
//  Created by Larry N on 11/7/20.
//

import SwiftUI

struct ProfileSettings: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var showImagePicker = false
    @State var imageData : Data = .init(count: 0)
    
    var body: some View {
        VStack {
            Button(action: {
                showImagePicker = true
            }, label: {
                if self.imageData.count == 0 {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .shadow(radius: 15)
                        .overlay(Circle().stroke(Color.white, lineWidth: 8))
                        .frame(width: 150, height: 150)
                }
                else{
                    if let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .shadow(radius: 15)
                            .overlay(Circle().stroke(Color.white, lineWidth: 8))
                            .frame(width: 150, height: 150)
                    }
                }
            })
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(imageData: self.$imageData)
        }
    }
}

struct ProfileSettings_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettings()
    }
}
