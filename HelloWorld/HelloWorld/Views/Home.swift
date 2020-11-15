//
//  ContentView.swift
//  HelloWorld
//
//  Created by Larry N on 11/4/20.
//

import SwiftUI

struct Home: View {
    @ObservedObject var sessionStore = SessionStore()
    
    init() {
        sessionStore.listen()
    }
    
    @State var keyboardDisplayed = false
    @State var index = 0
        
    var body: some View {
        ChatList()
            .fullScreenCover(isPresented: $sessionStore.isAnon, content: {

                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 20, opaque: true)
                    
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
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
                                    
                                }.background(index == 0 ? Color.white.opacity(0.7) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                //                        .animation(.easeIn)
                                
                                Button(action: {
                                    index = 1                                    
                                }) {
                                    
                                    Text("new")
                                        .foregroundColor(self.index == 1 ? .black : .white)
                                        .fontWeight(.bold)
                                        .padding(.vertical, 10)
                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                    
                                }.background(index == 1 ? Color.white.opacity(0.7) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                //                        .animation(.easeIn)
                            }
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(Color.black.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, keyboardDisplayed ? 0 : 25)
                        }
                        .padding(.bottom, 25)
                                        
                        if index == 0 {
                            Login(keyboardDisplayed: $keyboardDisplayed)
                        } else {
                            Register(keyboardDisplayed: $keyboardDisplayed)
                        }
                        Spacer()
                    }
                    .animation(.easeInOut)

//                    .frame(height: UIScreen.main.bounds.height - 200)
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
        Home()
    }
}
