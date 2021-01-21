//
//  WelcomeView.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct WelcomeView: View {
  @EnvironmentObject var sessionStore: SessionStore
  @State var optionSelected = 0 // login = 0, register = 1
  
  var body: some View {
    // User is not logged in, present login/register views
    ZStack {
      Constants.primary.edgesIgnoringSafeArea(.all)
      
      VStack(spacing: 30) {
        // MARK:  logo/title
        Image("Logo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 125)
          .padding(.top, 20)
        
        Text("hello, world")
          .font(.largeTitle)
          .foregroundColor(Constants.textColor)
          .fontWeight(.bold)
        
        // MARK:  login/register buttons
        HStack(spacing: 0) {
          Button(action: { optionSelected = 0}) {
            Text("login")
              .welcomeFormat(optionNumber: 0, optionSelected)
          }
          
          Button(action: { optionSelected = 1 }) {
            Text("register")
              .welcomeFormat(optionNumber: 1, optionSelected)
          }
        }
        .frame(width: Constants.contentWidth)
        .background(Constants.secondaryColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadowStyle()
        
        // MARK:  Login/Register views
        if optionSelected == 0 {
          LoginView()
            .transition(
              AnyTransition.asymmetric(
                insertion: .move(edge: .trailing),
                removal: AnyTransition.move(edge: .leading).combined(with: .opacity)))
        } else {
          RegisterView()
            .transition(
              AnyTransition.asymmetric(
                insertion: .move(edge: .leading),
                removal: AnyTransition.move(edge: .trailing).combined(with: .opacity)))
        }
        Spacer()
      }
      .animation(.easeInOut)
    }
    .onTapGesture {
      self.hideKeyboard()
    }
    .onAppear {
      sessionStore.listen()
    }
    .fullScreenCover(isPresented: $sessionStore.isSignedIn, onDismiss: sessionStore.fetchUser) {
      HomeView(tabSelection: 1).environmentObject(SessionStore())
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView().environmentObject(SessionStore())
  }
}
