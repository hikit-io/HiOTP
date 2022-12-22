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

struct OtpRow: View {
    
    private var otpInfo:OtpInfo;
    
    private var secret:Data;
    
    private var totp:TOTP;
    
    @State private var number = "000000";
    
    @State private var interval = 30;
    
    @State private var lasttime = 0;
    
    private var onClick:()->Void
    
    @State private var textColor = Color.blue
    @State private var textOpacity = 1.0
    
    @Binding private var  tick:Double;
    
    init(otpInfo: OtpInfo,tick:Binding<Double>,onClick:@escaping ()->Void) {
        self.otpInfo = otpInfo
        
        self.secret = (otpInfo.secret ?? "").base32DecodedData ?? Data()
        
        self.totp = TOTP(secret: self.secret, digits: Int(otpInfo.digits), timeInterval: Int(otpInfo.period), algorithm: .sha1)!
        let now = Int32(Date().timeIntervalSince1970)
        
        _interval = State(initialValue: Int(otpInfo.period-now%otpInfo.period))
        
        _number = State(initialValue: (self.totp.generate(secondsPast1970: Int(now)))!)
        
        _tick = tick
        
        self.onClick = onClick
    }
    
    let fontNote = {
#if !os(watchOS)
        Font.body
#else
        Font.footnote
#endif
    }()
    
    struct IssuerTime:View{
        var issuer:String
        var body: some View{
            HStack{

                Text(issuer).font(.title3)
                Spacer()
#if !os(watchOS)
                Text("2021/02/02 10:48")
                    .font(.footnote)
                    .foregroundColor(.gray)
#endif
            }
        }
        
    }
    
    func copyToPastboard(str:String){
#if os(iOS)
        UIPasteboard.general.string = str
#endif
#if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(str, forType: .string)
#endif
    }
    
    var body: some View {
        VStack(alignment: .leading){
            IssuerTime(issuer: otpInfo.issuer ?? "")
            Text(number)
                .font(.largeTitle)
                .foregroundColor(textColor)
                .opacity(textOpacity)
                .animation(.linear, value: textOpacity)
            HStack{
                Text(otpInfo.email ?? "")
                    .font(fontNote)
                    .foregroundColor(.gray)
                Spacer()
                Text(interval.formatted()+"s")
                    .font(fontNote)
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            copyToPastboard(str: number)
            self.onClick()
        }.onChange(of: tick) { newValue in
            let diff = newValue - Double(Int64(newValue))
            
            if diff == 0{
                let now = Int(Date().timeIntervalSince1970)
                number = (self.totp.generate(secondsPast1970: now ))!
                interval = Int(otpInfo.period) - now % Int(otpInfo.period)
            }
           
            if interval > 5 {
                if textColor != .blue{
                    textColor = .blue
                }
                if textOpacity != 1.0 {
                    textOpacity  = 1
                }
            }else{
                if textColor != .red{
                    textColor = .red
                }
                if diff == 0{
                    textOpacity = 0.5
                }else{
                    textOpacity = 1
                }
//                if !(interval % 2 == 0 ){
//                    textOpacity = 0.5
//                }else{
//                    textOpacity = 1
//                }
            }
        }
        
    }
}
//
//struct OtpRow_Previews: PreviewProvider {
//
//
//    struct OtpRowPreview: View{
//        @State var tick:Int64 = 0
//
//        var body: some View{
//            OtpRow(otpInfo: OtpRow_Previews.getOtp(), tick: $tick, onClick: {})
//        }
//    }
//
//    static var previews: some View {
//        OtpRowPreview()
//    }
//
//    static func getOtp()->OtpInfo{
//        let opt = OtpInfo()
//        opt.username = "123"
//        opt.created = Date()
//        return opt
//    }
//}

struct OtpDetail:View{
    private var otp:OtpInfo
    
    init(otp: OtpInfo) {
        self.otp = otp
    }
    
    var body: some View{
        Text(verbatim: otp.email ?? "")
    }
}
