//
//  modeButtons.swift
//  jogpm
//
//  Created by mrdog233o5 on 12/11/2023.
//

import Foundation

enum JogpmMode: String, Codable, CaseIterable {
    case gen = "Generate",
    save = "Save",
    get = "Get"
    
    var type: String {
        switch self {
        case .gen:
            return "gen"
        case .save:
            return "save"
        case .get:
            return "get"
        }
    }
}
