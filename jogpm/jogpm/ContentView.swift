//
//  ContentView.swift
//  jogpm
//
//  Created by mrdog233o5 on 12/11/2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("jogpmMode") var jogpmMode: JogpmMode = .gen
    var body: some View {
        VStack {
            Text("JogPM")
                .font(.title)
                .fontWeight(.bold)
                .padding([.horizontal], 50.0)
                .padding([.vertical], 5.0)
            VStack {
                ForEach(JogpmMode.allCases, id: \.self) { item in
                    Button {
                        
                    } label: {
                        Text(item.rawValue)
                            .foregroundColor(Color.primary)
                            .frame(width: 100.0)
                    }
                }
            } .frame(height: 80)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
