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
    @State var length = ""
    @State var passwdName = ""
    @State var passwd = ""
    @State var output = ""
    let btnWidth = 140.0
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
                            Text(stuff).frame(width: btnWidth, height: btnWidth*0.3)
                        }
                        ).frame(width: btnWidth)
                            .padding(2)
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
                        text: $length
                    ).frame(width: btnWidth)
                }
                Button(action: {
                    if (isNumeric(string: length) && (Int(length)!) > 0 && (Int(length)!) < 100) {
                        let passwordLength = Int32(length)!
                        self.output = ""
                        self.output = String(cString: gen(passwordLength, char, num, syb), encoding: .utf8)!
                    } else {
                        self.output = "invaid length"
                    }
                }, label : {
                    Text("Generate").frame(width: btnWidth)
                }
                ).frame(width: btnWidth)
                
                Text(output)
                    .frame(width: btnWidth, height: btnWidth*0.8)
                    .background(.fill)
                    .cornerRadius(10.0)
                Button(action: {
                    jogpm().copyStuff(output)
                }, label : {
                    Text("Copy").frame(width: btnWidth)
                })
            } else if (self.mode == "Save") {
                TextField(
                    "Passwd name",
                    text: $passwdName
                )
                    .frame(width: btnWidth)
                TextField(
                    "Passwd",
                    text: $passwd
                )
                    .frame(width: btnWidth)
                Button(action: {
                }, label : {
                    Text("Save").frame(width: btnWidth)
                })
            }
        }.padding()
    }
}

struct menuPage_Previews: PreviewProvider {
    static var previews: some View {
        menuPage().frame(width: 225, height: 450)
    }
}
