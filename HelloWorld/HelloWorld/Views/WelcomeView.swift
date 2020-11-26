//
//  WelcomeView.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var sessionStore = SessionStore()
    
    @State var keyboardDisplayed = false
    @State var optionSelected = 0 // login = 0, register = 1
    
    init() {
        sessionStore.listen()
    }
    
    var body: some View {
        Home(tabSelection: 1).fullScreenCover(isPresented: $sessionStore.isAnon) {
            // User is not logged in, present login/register views
            ZStack {
                Constants.gradientBackground.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    
                    // MARK:  logo/title
                    
                    
                    if !keyboardDisplayed { // remove when keyboard appears for more space
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                            .padding(.top, 20)
                            .transition(.move(edge: .top))
                        
                        VStack(alignment: .leading) {
                            Text("hello, world")
                                .font(.largeTitle)
                                .foregroundColor(Constants.title)
                                .fontWeight(.bold)
                        }
                        .transition(.fade)
                    }
                    
                    // MARK:  login/register buttons
                    
                    HStack {
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
                    .background(Color.black.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, keyboardDisplayed ? 10 : 25)
                    
                    // MARK:  Login/Register views
                    
                    if optionSelected == 0 {
                        LoginView(keyboardDisplayed: $keyboardDisplayed)
                            .transition(
                                AnyTransition.asymmetric(
                                    insertion: .move(edge: .trailing),
                                    removal: AnyTransition.move(edge: .leading).combined(with: .opacity)))
                    } else {
                        RegisterView(keyboardDisplayed: $keyboardDisplayed)
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
                self.keyboardDisplayed = false
                self.hideKeyboard()
            }
        }
    }
}

// MARK:  Extensions

private extension Text {
    func welcomeFormat(optionNumber: Int, _ optionSelected: Int) -> some View {
        self
            .fontWeight(.bold)
            .foregroundColor(optionSelected == optionNumber ? Constants.title : .secondary)
            .padding(.vertical, 10)
            .frame(width: (Constants.contentWidth) / 2)
            .background(optionSelected == optionNumber ? Constants.fill : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
