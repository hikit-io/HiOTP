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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
