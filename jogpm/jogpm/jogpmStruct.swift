//
//  jogpm.swift
//  jogpm
//
//  Created by mrdog233o5 on 13/11/2023.
//

import Foundation

func copyStuff(_ cmd: String) {
    let process = Process()
    let command = "echo \"" + cmd + "\" | pbcopy"
    process.launchPath = "/usr/bin/env" // Set the launch path to the shell environment
    process.arguments = ["bash", "-c", command] // Set the arguments to execute the command in the shell

    let outputPipe = Pipe()
    process.standardOutput = outputPipe // Set the standard output to the pipe

    process.launch()
    process.waitUntilExit()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    if let outputString = String(data: outputData, encoding: .utf8) {
        print(outputString)
    }
}

func account(_ line: Int) -> String {
    setup()
    let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].path+"/account.conf"
    let contents = try! String(contentsOfFile: path)
    let lines = contents.components(separatedBy: "\n")
    return String(lines[line])
}

func accountSet(_ line:Int,_ value:String) {
    setup()
    let fileManager = FileManager.default
    let path = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].path+"/account.conf"
    let contents = try! String(contentsOfFile: path)
    var lines = contents.components(separatedBy: "\n")
    lines[line] = value
    let res = lines.joined(separator: "\n").data(using: .utf8)
    fileManager.createFile(atPath: path, contents: res, attributes: nil)
}

func setup() {
    let fileManager = FileManager.default
    let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].path+"/account.conf"
    if !fileManager.fileExists(atPath: path) {
        fileManager.createFile(atPath: path, contents: "\n\n".data(using: .utf8), attributes: nil)
    }
}

struct PasswordInList: Identifiable {
    let name: String
    let id = UUID()

    init(name: String) {
        self.name = name
    }
}
