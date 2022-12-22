//
//  Setting.swift
//  HiOTP
//
//  Created by NAW on 2022/7/4.
//

import SwiftUI

struct Setting: View {
    
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @AppStorage("debugHidden") private var debugHidden = true;
    
    @State private var onIcloud = false;
    var body: some View {
#if os(iOS)
        Form{
            Section(header: Text("setting_data")){
                Toggle(isOn: $onIcloud){
                    Label("setting_icloud_sync", systemImage: "icloud")
                }.buttonStyle(.plain)
                NavigationLink {
                    Export()
                } label: {
                    Label("setting_export_qrcode", systemImage: "qrcode")
                }
                Button(action: onButton) {
                    Label("setting_export_sync_watch", systemImage: "applewatch")
                }.buttonStyle(.plain)
            }
            Section(header: Text("setting_about")){
                HStack{
                    Text("setting_version")
                    Spacer()
                    Text("0.0.1").foregroundColor(.gray)
                }.onTapGesture(count:5) {
                    debugHidden = false
                }
                NavigationLink("setting_privacy") {
                    Privacy()
                }
                NavigationLink("setting_copyright") {
                    Privacy()
                }
                if !debugHidden{
                    NavigationLink("Debug") {
                        Debug()
                    }
                }
            }
        }
        
#elseif os(macOS)
        TabView {
            Toggle("setting_menu_bar", isOn: $showMenuBarExtra)
                .tabItem {
                    Label("setting_common", systemImage: "circle")
                }
            Privacy()
                .tabItem{
                    Label("setting_privacy", systemImage: "privacy")
                }
        }
#else
        Form{
            HStack{
                Text("setting_version")
                Spacer()
                Text("0.0.1").foregroundColor(.gray)
            }
            NavigationLink("setting_privacy") {
                Privacy()
            }
            NavigationLink("setting_copyright") {
                Privacy()
            }
        }
#endif
    }
    
    func onButton()->Void{
        print("click")
    }
    
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
    }
}
