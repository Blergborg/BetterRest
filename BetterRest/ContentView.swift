//
//  ContentView.swift
//  BetterRest
//
//  Created by Phil Prater on 8/31/23.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    var body: some View {
        VStack {
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
