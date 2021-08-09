//
//  ContentView.swift
//  GravityTestApp
//

import Foundation
import SwiftUI
import Combine
import WebKit
import UIKit

struct ContentView: View {
    @State private var gameIsRunning = false
    
    let screenWidth = UIScreen.main.bounds.width/3
    let screenHeight = UIScreen.main.bounds.height/2.5
    
    @State private var timeRemaining = 7
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var tapCount = 0
    @State private var winTapCount = 10
    
    @ObservedObject var viewModel = ViewModel()
    @State var isLoaderVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("bg")
                    .interpolation(.none)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                if gameIsRunning {
                    VStack {
                        HStack(alignment: .top, spacing: 100) {
                            Text("Time: \(timeRemaining)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(Color.yellow)
                                )
                                .overlay(Capsule().stroke(Color.init(#colorLiteral(red: 0.9997933507, green: 0.8670455813, blue: 0.3345668614, alpha: 1)), lineWidth: 5))
                                .shadow(color: .white, radius: 30, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                            
                            
                            Text("Tap count: \(tapCount)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color: .white, radius: 10, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                            
                        }
                        .offset(x: 0, y: -300)
                        
                        Image("image")
                            .resizable()
                            .frame(width: 125, height: 100, alignment: .center)
                            .shadow(color: .white, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                            .offset(x: CGFloat.random(in: 0..<screenWidth), y: CGFloat.random(in: 0..<screenHeight))
                            .animation(.interpolatingSpring(stiffness: 20, damping: 50))
                            .onTapGesture {
                                tapCount += 1
                            }
                    }
                    .onReceive(timer) { time in
                        if self.timeRemaining > 0 {
                            self.timeRemaining -= 1
                        }
                    }
                }
                
                else {
                    VStack {
                        Image("logo")
                            
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .shadow(color: .white, radius: 15, x: 0, y: 0)
                            .shadow(color: .white, radius: 30, x: 0, y: 0)
                            .animation(.interpolatingSpring(stiffness: 20, damping: 20))
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "gamecontroller.fill")
                                Text("Rules:")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .shadow(color: .white, radius: 25)
                            }
                            Text("To win you have to touch the aim 10 times faster than 7 seconds.")
                                .font(.callout)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.init(#colorLiteral(red: 0.2606997192, green: 0, blue: 0.5211161375, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 3))
                        .animation(.interpolatingSpring(stiffness: 20, damping: 20))
                        
                        Spacer()
                        
                        Button(action: {
                            gameIsRunning.toggle()
                        }, label: {
                            Text("Play")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .shadow(color: .white, radius: 2)
                        })
                        .padding(.horizontal, 100)
                        .padding(.vertical, 20)
                        .background(Color.init(#colorLiteral(red: 0.348922044, green: 0.0725947395, blue: 0.5339946747, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(RoundedRectangle(cornerRadius: 15.0).stroke(LinearGradient(gradient: Gradient(colors: [Color.init(#colorLiteral(red: 1, green: 0, blue: 0.743436873, alpha: 1)), Color.white, Color.init(#colorLiteral(red: 1, green: 0, blue: 0.743436873, alpha: 1)),]), startPoint: .bottomLeading, endPoint: .topTrailing), lineWidth: 5))
                        .shadow(color: .white, radius: 10)
                        .animation(.interpolatingSpring(stiffness: 20, damping: 20))
                        
                        Spacer()
                    }
                }
                    if tapCount == 10 && timeRemaining != 0 {
                        VStack {
                            WebNavigationView(viewModel: viewModel)
                            WebView(type: .public, url: "https://www.google.com.ua", viewModel: viewModel)
                        }
                        .onReceive(self.viewModel.isLoaderVisible.receive(on: RunLoop.main)) { value in
                            self.isLoaderVisible = value
                        }
                        if isLoaderVisible {
                            LoaderView()
                        }
                    }
                    else if tapCount < 10 && timeRemaining == 0 {
                        VStack {
                            WebNavigationView(viewModel: viewModel)
                            WebView(type: .public, url: "https://www.youtube.com", viewModel: viewModel)
                        }
                        .frame(height: 750)
                        .onReceive(self.viewModel.isLoaderVisible.receive(on: RunLoop.main)) { value in
                            self.isLoaderVisible = value
                        }
                        if isLoaderVisible {
                            LoaderView()
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
