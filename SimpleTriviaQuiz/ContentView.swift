//
//  ContentView.swift
//  SimpleTriviaQuiz
//
//  Created by Neal Archival on 3/24/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Trivia Quiz App")
                    .font(.system(size: 42, weight: .bold))
                NavigationLink(destination: TriviaGame()) {
                    Text("Start")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(Color.white)
                        .frame(width: 180, height: 60)
                        .background(Color.blue)
                        .cornerRadius(12)
                } // Button
            } // VStack
            .padding([.leading, .trailing])
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
