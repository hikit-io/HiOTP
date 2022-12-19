//
//  HiOtpApp.swift
//  HiOtp Watch App
//
//  Created by NAW on 2022/7/1.
//

import SwiftUI
import CoreData


@main
struct HiOtp_Watch_AppApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
//            NavigationStack {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            }
        }
    }
}
