//
//  ContentView.swift
//  HiOTP
//
//  Created by NAW on 2022/7/1.
//

import SwiftUI
import CoreData
#if canImport(AlertToast)
import AlertToast
#endif

#if os(iOS)
import CodeScanner
#endif

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showToast = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \OtpInfo.created, ascending: true)],
        animation: .default)
    private var otps: FetchedResults<OtpInfo>
    
    @State private var showScan = false
    @State private var scanResult = true
    @State private var showAlert = false
    
    
    let listStyle = {
        #if os(iOS)
            SidebarListStyle()
        #elseif os(watchOS)
            DefaultListStyle()
        #endif
    }()
    
    var body: some View {
#if os(iOS) || os(watchOS)
        NavigationStack{
            OtpList(onItemClick: {
                showToast = true
            })
            .navigationTitle("Hi OTP")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(listStyle)
#if os(iOS)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        Setting()
                    } label: {
                        Label("Setting", systemImage: "gear")
                    }
                }
                ToolbarItem {
                    Button(action: {
                        showScan = true
                    }) {
                        Label("Add", systemImage: "qrcode.viewfinder")
                    }
                }
            }
#endif
        }
#if os(iOS)
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode:.alert,type: .regular, title: "Copy success")
        }

        .sheet(isPresented: $showScan) {
            NavigationStack{
                CodeScannerView(codeTypes: [.qr], scanMode: .continuous,manualSelect: true, showViewfinder: true, simulatedData: "Paul Hudson") { response in
                    switch response {
                    case .success(let result):
                        if result.string != "hh"{
                            showAlert = true
                        }else{
                            showScan = false
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }.navigationTitle(Text("扫描二维码"))
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("二维码有误"),message: Text("asd   "),dismissButton: .cancel())
            }
        }
#endif
#elseif os(macOS)
        NavigationSplitView(columnVisibility:.constant(.all),sidebar: {
            List {
                NavigationLink {
                    OtpList(onItemClick: {
                        showToast = true
                    })
                } label: {
                    Text("Home")
                }
            }
        },content: {
            OtpList(onItemClick: {
                showToast = true
            })
            
        },detail: {
            OtpMain()
        }).toast(isPresenting: $showToast) {
            AlertToast(displayMode:.alert,type: .regular, title: "Copy success")
        }
#endif
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
