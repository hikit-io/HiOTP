//
//  AddOtp.swift
//  HiOTP
//
//  Created by Nekilc on 2022/12/21.
//

import SwiftUI

class OtpInfoInput:ObservableObject{
    @Published var secret:String = ""
    @Published var account:String = ""
}

struct AddOtp: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var otp:OtpInfoInput = OtpInfoInput()
    
    @State private var showAlert = false
    @State private var alertMsg = ""
    var body: some View {
        Form{
            TextField("账号", text: $otp.account)
            TextField("秘钥", text: $otp.secret)
            Button("Add") {
                addOtp()
                showAlert = true
                alertMsg = "Add success"
            }
        }.alert(isPresented: $showAlert) {
            
            Alert(title:Text(alertMsg))
        }
    }
    
    func addOtp(){
        let newOtpInfo  = OtpInfo(context: viewContext )
        newOtpInfo.secret = self.otp.secret
        newOtpInfo.issuer = self.otp.account
        newOtpInfo.email = ""
        newOtpInfo.created = Date()
        newOtpInfo.digits = 6
        newOtpInfo.period = 30
        
        try? viewContext.save()
    }
}

struct AddOtp_Previews: PreviewProvider {
    static var previews: some View {
        AddOtp()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
