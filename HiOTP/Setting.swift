//
//  Setting.swift
//  HiOTP
//
//  Created by NAW on 2022/7/4.
//

import SwiftUI

struct Setting: View {
    
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    
    
    @State private var onIcloud = false;
    var body: some View {
#if os(iOS)
        Form{
            Section(header: Text("Data")){
                Toggle(isOn: $onIcloud){
                    Label("iCloud同步", systemImage: "icloud")
                }.buttonStyle(.plain)
                NavigationLink {
                    Export()
                } label: {
                    Label("导出为二维码", systemImage: "qrcode")
                }
                Button(action: onButton) {
                    Label("同步至手表", systemImage: "applewatch")
                }.buttonStyle(.plain)
            }
            Section(header: Text("Info")){
                
                HStack{
                    Text("版本")
                    Spacer()
                    Text("0.0.1").foregroundColor(.gray)
                }
                NavigationLink("隐私协议") {
                    Privacy()
                }
                NavigationLink("版权声明") {
                    Privacy()
                }
            }
        }
#endif
#if os(macOS)
        TabView {
            Toggle("在状态栏中显示", isOn: $showMenuBarExtra)
                .tabItem {
                    Label("通用", systemImage: "circle")
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
