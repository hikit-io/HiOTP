//
//  HiOTPApp.swift
//  HiOTP
//
//  Created by NAW on 2022/7/1.
//

import SwiftUI

@main
struct HiOTPApp: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
#if os(macOS)
        Settings {
            Setting().frame(width: 400,height: 200,alignment: .center)
        }
        MenuBarExtra("App Menu Bar Extra", systemImage: "star",isInserted: $showMenuBarExtra){
            MenuBarContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .menuBarExtraStyle(WindowMenuBarExtraStyle())
        
#endif
    }
}
