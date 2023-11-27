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
    let path = Bundle.main.resourceURL!.path+"/account.conf"
    let contents = try! String(contentsOfFile: path)
    let lines = contents.split(separator:"\n")
    return String(lines[line])
}
