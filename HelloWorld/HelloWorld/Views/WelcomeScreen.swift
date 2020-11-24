//
//  WelcomeScreen.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct WelcomeScreen: View {
    @ObservedObject var sessionStore = SessionStore()
    
    @State var keyboardDisplayed = false
    @State var index = 0
    
    init() {
        sessionStore.listen()
    }
    
    var body: some View {
        Home(tabSelection: 1)
            .fullScreenCover(isPresented: $sessionStore.isAnon, content: {
                
                ZStack {
                    Constants.gradientBackground
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        VStack(spacing: 30) {
                            if !keyboardDisplayed {
                                Image("IconClear")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150)
                                    .padding(.top, 20)
                                    .transition(.move(edge: .top))
                                
                                VStack(alignment: .leading) {
                                    Text("hello, world")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                                .transition(.fade)
                            }
                            
                            HStack {
                                Button(action: {
                                    index = 0
                                }) {
                                    
                                    Text("existing")
                                        .foregroundColor(index == 0 ? .black : .white)
                                        .fontWeight(.bold)
                                        .padding(.vertical, 10)
                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                    
                                }.background(index == 0 ? Color.white : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                Button(action: {
                                    index = 1                                    
                                }) {
                                    
                                    Text("new")
                                        .foregroundColor(index == 1 ? .black : .white)
                                        .fontWeight(.bold)
                                        .padding(.vertical, 10)
                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                    
                                }.background(index == 1 ? Color.white : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(Color.black.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, keyboardDisplayed ? 0 : 25)
                        }
                        .padding(.bottom, 25)
                        
                        if index == 0 {
                            Login(keyboardDisplayed: $keyboardDisplayed)
                                .transition(AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: AnyTransition.move(edge: .leading).combined(with: .opacity)))
                        } else {
                            Register(keyboardDisplayed: $keyboardDisplayed)
                                .transition(AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: AnyTransition.move(edge: .trailing).combined(with: .opacity)))
                        }
                        Spacer()
                    }
                    .animation(.easeInOut)
                }
                .onTapGesture {
                    self.keyboardDisplayed = false
                    self.hideKeyboard()
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
