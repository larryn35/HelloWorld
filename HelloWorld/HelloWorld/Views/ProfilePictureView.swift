//
//  ProfilePictureView.swift
//  HelloWorld
//
//  Created by Larry N on 12/4/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfilePictureView: View {
    var image: Image?
    var photoURL: String
    
    var body: some View {
        Group {
            // user changed image
            if image != nil {
                image?
                    .resizable()
                    .imageStyle()
                
                // user has profile picture
            } else if photoURL != "" {
                WebImage(url: URL(string: photoURL))
                    .resizable()
                    .placeholder {
                        Circle().foregroundColor(Constants.primary)
                    }
                    .imageStyle()
                
                // user has not set profile picture
            } else {
                Image("DefaultProfilePicture")
                    .resizable()
                    .imageStyle()
            }
        }
    }
}


//struct ProfilePictureView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePictureView(photoURL: <#String#>)
//    }
//}
