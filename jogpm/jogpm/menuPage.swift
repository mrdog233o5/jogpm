//
//  MenuPage.swift
//  jogpm
//
//  Created by mrdog233o5 on 12/11/2023.
//

import SwiftUI

struct menuPage: View {
    @State var mode: String = "idk"
    var body: some View {
        VStack {
            Text("JogPM")
                .font(.title)
                .fontWeight(.bold)
                .padding([.horizontal], 50.0)
                .padding([.vertical], 5.0)
            VStack {
                let btnWidth = 100.0
                let btnNames = ["Generate", "Save", "Get"]
                ForEach(btnNames, id: \.self) { stuff in
                    Button(action: {
                        self.mode=stuff
                    }, label : {
                        Text(stuff).frame(width: btnWidth)
                    }
                    ).frame(width: btnWidth)
                }
            } .frame(height: 80)
        }
    }
}


struct menuPage_Previews: PreviewProvider {
    static var previews: some View {
        menuPage()
    }
}
