//
//  Export.swift
//  HiOTP
//
//  Created by Nekilc on 2022/12/19.
//

import SwiftUI
import LocalAuthentication

struct ExportItem: View{
    
    private var otp:OtpInfo
    
    @State private var checked:Bool = false
    
    private var onCheck: (_ item:OtpInfo,_ checked:Bool)->Void
    
    init(otp: OtpInfo, onCheck: @escaping (_ item:OtpInfo,_ checked:Bool)->Void){
        self.otp = otp
        self.onCheck = onCheck
    }
    
    var body: some View{
        Toggle(isOn: $checked){
            VStack{
                HStack{
                    Text(verbatim: otp.issuer ?? "")
                        .font(.title3)
                    Spacer()
                    Text(verbatim: otp.created?.formatted() ?? "")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                HStack{
                    Text(verbatim: otp.email ?? "")
                        .font(.body)
                        .foregroundColor(.gray)
                    Spacer()
                }
            }.padding([.top,.bottom],5)
        }
        .toggleStyle(CheckBoxStyle())
        .onChange(of: checked) { newValue in
            self.onCheck(self.otp,newValue)
        }
    }
    
    struct CheckBoxStyle: ToggleStyle{
        func makeBody(configuration: Configuration) -> some View {
            let systemName = configuration.isOn ? "checkmark.circle.fill":"circle"
            Button(action: {
                configuration.isOn.toggle()
            }) {
                HStack{
                    Image(systemName: systemName).resizable().frame(width: 30,height: 30).foregroundColor(.blue)
                    Spacer()
                    configuration.label
                }
            }.buttonStyle(.plain)
        }
    }
}

struct Export: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var path:PathManager
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \OtpInfo.created, ascending: true)],
        animation: .default)
    private var items: FetchedResults<OtpInfo>
    
    @State private var isOn = false
    
    @State private var selected:Set<OtpInfo> = Set()
    
    @State private var authed = false
    
    var body: some View {
        VStack{
            if authed{
                List{
                    ForEach(items) { otp in
                        ExportItem(otp: otp) { (otp,checked) in
                            if checked{
                                self.selected.insert(otp)
                            }else{
                                self.selected.remove(otp)
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button(action: exportSelected) {
                            Text("导出")
                        }
                    }
                }
            }else{
                Button("Back") {
                    path.path.removeLast()
                }
            }
        }.onAppear(perform: auth)
    }
    
    func exportSelected(){
        print(self.selected)
    }
    
    func auth(){
        let ctx = LAContext()
        var err:NSError?
        
        if ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err){
            let reason = "Continue"
            ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { ok, error in
                if ok{
                    authed = true
                }else{
                    let error = error as! NSError
                    switch error.code{
                    case -2:
                        path.path.removeLast()
                    default:
                        path.path.removeLast()
                    }
                }
                print(error as Any)
            }
        }
        if err != nil{
            if ctx.canEvaluatePolicy(.deviceOwnerAuthentication, error: &err){
                let reason = "Continue"
                ctx.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { ok, error in
                    if ok{
                        authed = true
                    }
                    print(error as Any)
                }
            }
        }
        
    }
}

struct Export_Previews: PreviewProvider {
    static var previews: some View {
        Export()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
