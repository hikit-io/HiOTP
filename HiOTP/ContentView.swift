//
//  ContentView.swift
//  HiOTP
//
//  Created by NAW on 2022/7/1.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \OtpInfo.created, ascending: true)],
        animation: .default)
    private var otps: FetchedResults<OtpInfo>
    
    var body: some View {
        NavigationView {
            OtpList()
            .navigationTitle("HiOTP")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.sidebar)
#endif
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarLeading
                ) {
                    Button(action: addItem) {
                        Label("Setting", systemImage: "gear")
                    }
                }

                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add", systemImage: "qrcode.viewfinder")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {

            let newOtpInfo = OtpInfo(context: viewContext)
            newOtpInfo.email = "nieaowei@hikit.io"
            newOtpInfo.created = Date()
            newOtpInfo.secret = "nieaowei"
            newOtpInfo.digits = 6
            newOtpInfo.period = 30
            newOtpInfo.username = "123"
            newOtpInfo.issuer = "HiKit"
            newOtpInfo.t0 = Int64(Date().timeIntervalSince1970)-15
//            newOtpInfo.algorithm = "SHA256"
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
