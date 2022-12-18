//
//  OtpRow.swift
//  HiOTP
//
//  Created by NAW on 2022/7/1.
//

import SwiftUI
import SwiftOTP

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AlertToast)
import AlertToast
#endif

struct OtpRow: View {
    
    private var otpInfo:OtpInfo;
    
    private var secret:Data;
    
    private var totp:TOTP;
    
    @State private var number = "000000";
    
    @State private var interval = 30;
    
    @State private var lasttime = 0;
    
    private var onClick:()->Void
    
    @Binding private var  tick:Int64;
    
    init(otpInfo: OtpInfo,tick:Binding<Int64>,onClick:@escaping ()->Void) {
        self.otpInfo = otpInfo
        print(otpInfo.secret!)
        
        self.secret = otpInfo.secret!.base32DecodedData!
        
        self.totp = TOTP(secret: self.secret, digits: Int(otpInfo.digits), timeInterval: Int(otpInfo.period), algorithm: .sha1)!
        let now = Int32(Date().timeIntervalSince1970)
        
        _interval = State(initialValue: Int(otpInfo.period-now%otpInfo.period))
        
        _number = State(initialValue: (self.totp.generate(secondsPast1970: Int(now)))!)
        
        _tick = tick
        
        self.onClick = onClick
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(otpInfo.issuer ?? "").font(.title3)
                Spacer()
                Text("2021/02/02 10:48")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Text(number)
                .font(.largeTitle)
                .foregroundColor(.blue)
            HStack{
                Text(otpInfo.email ?? "")
                    .foregroundColor(.gray)
                Spacer()
                Text(interval.formatted()+"s")
                    .foregroundColor(.gray)
            }
        }
        .padding(.all)
        .onTapGesture {
#if os(iOS)
            UIPasteboard.general.string = number
            
#endif
#if os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(number, forType: .string)
#endif
            self.onClick()
        }.onChange(of: tick) { newValue in
            let now = Int(Date().timeIntervalSince1970)
            number = (self.totp.generate(secondsPast1970: now ))!
            interval = Int(otpInfo.period) - now % Int(otpInfo.period)
        }
    }
    
}

//struct OtpRow_Previews: PreviewProvider {


//
//    static var previews: some View {
//
//        OtpRow(otpInfo: OtpInfo(),refersh: true) {
//
//        }
//    }
//
//    func getOtp()->OtpInfo{
//        let opt = OtpInfo()
//        opt.username = "123"
//        opt.created = Date()
//        return opt
//    }
//}
