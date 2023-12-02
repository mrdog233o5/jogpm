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

func listSavedPasswords() {
    let username = account(0)
    let password = account(1)
    let reqUrl: UnsafePointer<CChar> = ("https://jogpm-backend.vercel.app/list" as NSString).utf8String!
    let reqHeadersSwiftStr = ["username:\(username)", "password:\(password)"]
    let reqHeadersPtr = reqHeadersSwiftStr.map { strdup($0) }
    var reqHeadersUnsafePointers: [UnsafeMutablePointer<CChar>?] = reqHeadersPtr.map { UnsafeMutablePointer(mutating: $0) }
    let reqHeaders = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: reqHeadersUnsafePointers.count)
    reqHeaders.initialize(from: &reqHeadersUnsafePointers, count: reqHeadersUnsafePointers.count)

    let resRaw = String(cString: reqGet(reqUrl, reqHeaders, 2)).split(separator: " ")
    
    print(resRaw)
}

struct menuPage: View {
    @State var mode: String = "JogPM"
    @State var char = true
    @State var num = true
    @State var syb = false
    @State var length = ""
    @State var output = ""
    @State var output2 = ""
    @State var passwdName = ""
    @State var passwd = ""
    @State var passwdNameGet = ""
    @State var passwdGet = ""
    @State var username = ""
    @State var password = ""
    @State var accountUsername = ""
    @State var accountPassword = ""
    @State var passwdNew = ""
    @State var passwdNewVerify = ""
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
                    if (self.mode == "Signup" || self.mode == "Signin" || self.mode == "Change Passwd") {
                        self.mode = "Account"
                    } else {
                        self.mode="JogPM"
                    }
                    self.output = ""
                    self.output2 = ""
                }, label : {
                    Text("Back").frame(width: btnWidth)
                }).frame(width: btnWidth)
            }
            if (self.mode == "JogPM") {
                VStack {
                    let btnNames = ["Create", "Save", "Get", "Account", "Quit"]
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
                    }.toggleStyle(.checkbox)
                    Toggle(isOn: $num) {
                        Text("use numbers").frame(width: btnWidth)
                    }.toggleStyle(.checkbox)
                    Toggle(isOn: $syb) {
                        Text("use symbols").frame(width: btnWidth)
                    }.toggleStyle(.checkbox)
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
                    copyStuff(output)
                    self.output2 = "copied!"
                }, label : {
                    Text("Copy").frame(width: btnWidth)
                })
                Text(output2)
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
                    username = account(0)
                    password = account(1)
                    let reqUrl: UnsafePointer<CChar> = ("https://jogpm-backend.vercel.app/set" as NSString).utf8String!
                    let reqBody = "{'passwordName':'" + passwdName + "', 'password':'" + passwd + "'}"
                    let reqHeadersSwiftStr = ["username:\(username)", "password:\(password)"]
                    let reqHeadersPtr = reqHeadersSwiftStr.map { $0.utf8CString }
                    var reqHeadersUnsafePointers: [UnsafePointer<CChar>?] = reqHeadersPtr.map { $0.withUnsafeBufferPointer { $0.baseAddress } }
                    let reqHeaders = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(capacity: reqHeadersUnsafePointers.count)
                    reqHeaders.initialize(from: &reqHeadersUnsafePointers, count: reqHeadersUnsafePointers.count)

                    let res = String(cString: reqPost(reqUrl, reqBody, reqHeaders, 2))
                    self.output = res
                    
                }, label : {
                    Text("Save").frame(width: btnWidth)
                })
                Text(output2)
            } else if (self.mode == "Get") {
                TextField(
                    "Passwd name",
                    text: $passwdNameGet
                )
                    .frame(width: btnWidth)
                    .background(.fill)
                    .cornerRadius(radius)

                Button(action: {
                    username = account(0)
                    password = account(1)
                    let reqUrl: UnsafePointer<CChar> = ("https://jogpm-backend.vercel.app/get" as NSString).utf8String!
                    let reqHeadersSwiftStr = ["username:\(username)", "password:\(password)", "passwordName:"+passwdNameGet]
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
                    copyStuff(passwdGet)
                    self.output2 = "copied!"
                }, label : {
                    Text("Copy").frame(width: btnWidth)
                })
                Text(output2)
            } else if (self.mode == "Account") {
                VStack {
                    let btnNames = ["Signup", "Signin", "Change Passwd"]
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
            } else if (self.mode == "Signup") {
                TextField(
                    "Username",
                    text: $accountUsername
                )
                    .frame(width: btnWidth)
                    .background(.fill)
                    .cornerRadius(radius)
                TextField(
                    "Password",
                    text: $accountPassword
                )
                    .frame(width: btnWidth)
                    .background(.fill)
                    .cornerRadius(radius)
                Button(action: {
                    // signup
                    if (accountUsername != "" && accountPassword != "") {
                        // send POST request
                        let reqUrl: UnsafePointer<CChar> = ("https://jogpm-backend.vercel.app/signup" as NSString).utf8String!
                        let reqBody = "{}"
                        let reqHeadersSwiftStr = ["username:\(accountUsername)", "password:\(accountPassword)"]
                        let reqHeadersPtr = reqHeadersSwiftStr.map { $0.utf8CString }
                        var reqHeadersUnsafePointers: [UnsafePointer<CChar>?] = reqHeadersPtr.map { $0.withUnsafeBufferPointer { $0.baseAddress } }
                        let reqHeaders = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(capacity: reqHeadersUnsafePointers.count)
                        reqHeaders.initialize(from: &reqHeadersUnsafePointers, count: reqHeadersUnsafePointers.count)
                        let res = String(cString: reqPost(reqUrl, reqBody, reqHeaders, 2))
                        self.output = res
                        
                        setup()
                        let fileManager = FileManager.default
                        let path = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].path+"/account.conf"
                        let lines = [accountUsername, accountPassword]
                        let content = lines.joined(separator: "\n").data(using: .utf8)
                        fileManager.createFile(atPath: path, contents: content, attributes: nil)
                    }
                }, label : {
                    Text("Signup").frame(width: btnWidth)
                })
                Text(output)
            } else if (self.mode == "Signin") {
                TextField(
                    "Username",
                    text: $accountUsername
                )
                    .frame(width: btnWidth)
                    .background(.fill)
                    .cornerRadius(radius)
                TextField(
                    "Password",
                    text: $accountPassword
                )
                    .frame(width: btnWidth)
                    .background(.fill)
                    .cornerRadius(radius)
                Button(action: {
                    // sign in
                    accountSet(0, accountUsername)
                    accountSet(1, accountPassword)
                    self.output = "signed in"
                }, label : {
                    Text("Signin").frame(width: btnWidth)
                })
                Text(output)
            } else if (self.mode == "Change Passwd") {
                TextField(
                    "Old Passwd",
                    text: $accountPassword
                )
                    .frame(width: btnWidth)
                    .background(.fill)
                    .cornerRadius(radius)
                TextField(
                    "New Passwd",
                    text: $passwdNew
                )
                    .frame(width: btnWidth)
                    .background(.fill)
                    .cornerRadius(radius)
                TextField(
                    "Verify New Passwd",
                    text: $passwdNewVerify
                )
                    .frame(width: btnWidth)
                    .background(.fill)
                    .cornerRadius(radius)
                Button(action: {
                    // change password
                    setup()
                    accountUsername = account(0)
                    let reqUrl: UnsafePointer<CChar> = ("https://jogpm-backend.vercel.app/change" as NSString).utf8String!
                    let reqBody = "{'new':'\(passwdNew)', 'newVerify':'\(passwdNewVerify)'}"
                    let reqHeadersSwiftStr = ["username:\(accountUsername)", "password:\(accountPassword)"]
                    let reqHeadersPtr = reqHeadersSwiftStr.map { $0.utf8CString }
                    var reqHeadersUnsafePointers: [UnsafePointer<CChar>?] = reqHeadersPtr.map { $0.withUnsafeBufferPointer { $0.baseAddress } }
                    let reqHeaders = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(capacity: reqHeadersUnsafePointers.count)
                    reqHeaders.initialize(from: &reqHeadersUnsafePointers, count: reqHeadersUnsafePointers.count)
                    let res = String(cString: reqPost(reqUrl, reqBody, reqHeaders, 2))
                    if (res == "changed account password") {
                        accountSet(1, passwdNew)
                        self.output = "changed"
                    }
                }, label : {
                    Text("Change").frame(width: btnWidth)
                })
                Text(output)
            } else if (self.mode == "Quit") {
                exit(0)
            }
        }.padding()
    }
}

struct menuPage_Previews: PreviewProvider {
    static var previews: some View {
        menuPage().frame(width: 225, height: 450)
    }
}
