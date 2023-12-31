//
//  ApplicationMenu.swift
//  jogpm
//
//  Created by mrdog233o5 on 12/11/2023.
//

import Foundation
import SwiftUI

class ApplicationMenu: NSObject {
    let menu = NSMenu()
    
    func createMenu() -> NSMenu {
        let menuView = menuPage()
        let topView = NSHostingController(rootView: menuView)
        topView.view.frame.size = CGSize(width: 225, height: 450)
        
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view
        menu.addItem(customMenuItem)
        menu.addItem(NSMenuItem.separator())
        
        return menu
    }
}
