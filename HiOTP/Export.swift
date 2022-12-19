//
//  Export.swift
//  HiOTP
//
//  Created by Nekilc on 2022/12/19.
//

import SwiftUI

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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \OtpInfo.created, ascending: true)],
        animation: .default)
    private var items: FetchedResults<OtpInfo>
    
    @State private var isOn = false
    
    @State private var selected:Set<OtpInfo> = Set()
    
    var body: some View {
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
        
    }
    
    func exportSelected(){
        print(self.selected)
    }
}

struct Export_Previews: PreviewProvider {
    static var previews: some View {
        Export()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
