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

class PathManager:ObservableObject{
    @Published var path = NavigationPath()
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var path:PathManager = PathManager()
    
    @State private var showToast = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \OtpInfo.created, ascending: true)],
        animation: .default)
    private var otps: FetchedResults<OtpInfo>
    
    @State private var showScan = false
    @State private var scanResult = true
    @State private var showAlert = false
    @State private var tick = 1.0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
#if os(iOS)
        NavigationStack(path: $path.path){
            OtpList(onItemClick: {
                showToast = true
            })
            .navigationTitle("Hi OTP")
            .navigationBarTitleDisplayMode(.inline)
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
        .environmentObject(path)
#if os(iOS)
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode:.alert,type: .regular, title: String(localized: "copy_success"))
        }
        
        .sheet(isPresented: $showScan) {
            NavigationStack{
                CodeScannerView(codeTypes: [.qr], scanMode: .continuous,manualSelect: true, showViewfinder: true, simulatedData: "Debug") { response in
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
                }.navigationTitle(Text("scan_qrcode"))
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
                    Text("nav_home")
                }
            }
        },content: {
            OtpList(onItemClick: {
                showToast = true
            })
            
        },detail: {
            Group{
                if let otp = otps.first{
                    OtpRow(otpInfo: otp, tick: $tick,style: .main) {
                        print("main")
                    }
                }
            }
            
        }).toast(isPresenting: $showToast) {
            AlertToast(displayMode:.alert,type: .regular, title: String(localized: "copy_success"))
        }.onReceive(timer) { tim in
            tick += 0.5
        }
#else
        NavigationStack{
            TabView {
                OtpList(onItemClick: {
                    showToast = true
                })
                .navigationTitle("Hi OTP")
                Setting()
                    .navigationTitle("Hi OTP")
            }.tabViewStyle(.page)
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


struct MenuBarContentView:View{
    var body: some View{
        Group{
            OtpList {
                
            }
            .opacity(0.8)
            .cornerRadius(10)
        }.padding(.all)
    }
}
