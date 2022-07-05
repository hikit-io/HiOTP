//
//  Setting.swift
//  HiOTP
//
//  Created by NAW on 2022/7/4.
//

import SwiftUI

struct Setting: View {
    var body: some View {
        Form{
            Section{
                Button(action: onButton){
                    Label("Setting", systemImage: "gear")
                }.buttonStyle(.plain)
                Toggle(isOn: .constant(true)){
                    Label("Setting", systemImage: "gear")
                    Text("123")
                }
                Button("123", action: onButton)
            }
        
            Section{
                Button(action: onButton){
                    Label("Setting", systemImage: "gear")
                }.buttonStyle(.plain)
                Button("123", action: onButton)
                Button("123", action: onButton)
            }
        }
        
    }
    
    func onButton()->Void{
        
    }
    
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
    }
}
