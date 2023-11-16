//
//  MenuPage.swift
//  jogpm
//
//  Created by mrdog233o5 on 12/11/2023.
//

import SwiftUI


func isNumeric(string: String) -> Bool {
    let digitPattern = "^[0-9]+$"
    let regex = try! NSRegularExpression(pattern: digitPattern)
    let range = NSRange(location: 0, length: string.utf16.count)
    let matches = regex.matches(in: string, range: range)
    return !matches.isEmpty
}

struct menuPage: View {
    @State var mode: String = "JogPM"
    @State var char = true
    @State var num = true
    @State var syb = false
    @State var ssyb = false
    @State var len = ""
    @State var output: String = ""
    let btnWidth = 100.0
    var body: some View {
        VStack {
            Text(self.mode)
                .font(.title)
                .fontWeight(.bold)
                .padding([.horizontal], 50.0)
                .padding([.vertical], 5.0)
            if (self.mode != "JogPM") {
                Button(action: {
                    self.mode="JogPM"
                }, label : {
                    Text("Back").frame(width: btnWidth)
                }).frame(width: btnWidth)
            }
            if (self.mode == "JogPM") {
                VStack {
                    let btnNames = ["Create", "Save", "Get"]
                    ForEach(btnNames, id: \.self) { stuff in
                        Button(action: {
                            self.mode=stuff
                        }, label : {
                            Text(stuff).frame(width: btnWidth)
                        }
                        ).frame(width: btnWidth)
                    }
                }
            } else if (self.mode == "Create") {
                VStack {
                    Toggle(isOn: $char) {
                        Text("use characters").frame(width: btnWidth)
                    }
                    .toggleStyle(.checkbox)
                    Toggle(isOn: $num) {
                        Text("use numbers").frame(width: btnWidth)
                    }
                    .toggleStyle(.checkbox)
                    Toggle(isOn: $syb) {
                        Text("use symbols").frame(width: btnWidth)
                    }
                    .toggleStyle(.checkbox)
                    TextField(
                        "Length",
                        text: $len
                    ).frame(width: btnWidth)
                }
                Button(action: {
                    if (isNumeric(string: len) && (Int(len) ?? 0) > 0 && (Int(len) ?? 0) < 100) {
                        self.output = String(cString: test())
                    } else {
                        self.output = "invaid length"
                    }
                }, label : {
                    Text("Generate!").frame(width: btnWidth)
                }
                ).frame(width: btnWidth)
                
                Text(output)
                    .frame(width: btnWidth, height: btnWidth)
                    .background(.fill)
                    .padding(3)
                Button(action: {
                    jogpm().copyStuff(output)
                }, label : {
                    Text("Copy").frame(width: btnWidth)
                })
            }
        }.padding()
    }
}

struct menuPage_Previews: PreviewProvider {
    static var previews: some View {
        menuPage()
    }
}
