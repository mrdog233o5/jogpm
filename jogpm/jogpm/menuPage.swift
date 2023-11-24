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
    @State var output = ""
    @State var passwdName = ""
    @State var passwd = ""
    @State var passwdNameGet = ""
    @State var passwdGet = ""
    let btnWidth = 140.0
    let radius = 8.0
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
                }.padding(10)
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
                    )
                    .frame(width: btnWidth)
                    .background(.fill)
                    .cornerRadius(radius)
                }
                Button(action: {
                    if (isNumeric(string: length) && (Int(length)!) > 0 && (Int(length)!) < 100) {
                        let passwordLength = Int32(length)!
                        self.output = ""
                        self.output = String(cString: gen(passwordLength, char, num, syb), encoding: .utf8)!
                        self.passwd = self.output
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
                    .cornerRadius(radius)
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
                .background(.fill)
                .cornerRadius(radius)
                TextField(
                    "Passwd",
                    text: $passwd
                )
                .frame(width: btnWidth)
                .background(.fill)
                .cornerRadius(radius)
                Button(action: {

                    let reqUrl: UnsafePointer<CChar> = ("https://jogpm-backend.vercel.app/set" as NSString).utf8String!
                    let reqBody = "{'passwordName':'" + passwdName + "', 'password':'" + passwd + "'}"
                    let reqHeadersSwiftStr = ["username:mrdog233o5", "password:root"]
                    let reqHeadersPtr = reqHeadersSwiftStr.map { $0.utf8CString }
                    var reqHeadersUnsafePointers: [UnsafePointer<CChar>?] = reqHeadersPtr.map { $0.withUnsafeBufferPointer { $0.baseAddress } }
                    let reqHeaders = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(capacity: reqHeadersUnsafePointers.count)
                    reqHeaders.initialize(from: &reqHeadersUnsafePointers, count: reqHeadersUnsafePointers.count)

                    reqPost(reqUrl, reqBody, reqHeaders, 2)
                    
                }, label : {
                    Text("Save").frame(width: btnWidth)
                })
            } else if (self.mode == "Get") {
                TextField(
                    "Passwd name",
                    text: $passwdNameGet
                )
                .frame(width: btnWidth)
                .background(.fill)
                .cornerRadius(radius)

                Button(action: {

                    let reqUrl: UnsafePointer<CChar> = ("https://jogpm-backend.vercel.app/get" as NSString).utf8String!
                    let reqHeadersSwiftStr = ["username:mrdog233o5", "password:root", "passwordName:"+passwdNameGet]
                    let reqHeadersPtr = reqHeadersSwiftStr.map { strdup($0) }
                    var reqHeadersUnsafePointers: [UnsafeMutablePointer<CChar>?] = reqHeadersPtr.map { UnsafeMutablePointer(mutating: $0) }
                    let reqHeaders = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: reqHeadersUnsafePointers.count)
                    reqHeaders.initialize(from: &reqHeadersUnsafePointers, count: reqHeadersUnsafePointers.count)

                    passwdGet = String(cString: reqGet(reqUrl, reqHeaders, 3))
                    
                }, label : {
                    Text("Get").frame(width: btnWidth)
                })
                Text(passwdGet)
                    .frame(width: btnWidth, height: btnWidth*0.8)
                    .background(.fill)
                    .cornerRadius(radius)
                Button(action: {
                    jogpm().copyStuff(passwdGet)
                }, label : {
                    Text("Copy").frame(width: btnWidth)
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
