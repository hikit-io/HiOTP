//
//  OtpRow.swift
//  HiOTP
//
//  Created by NAW on 2022/7/1.
//

import SwiftUI
import SwiftOTP


struct OtpRow: View {
    
    private var otpInfo:OtpInfo;
    
    private var secret:Data;
    
    private var totp:TOTP;
    
    @State private var number = "000000";
   
    @State private var interval = 30;
   
    
    init(otpInfo: OtpInfo) {
        self.otpInfo = otpInfo
        print(otpInfo.secret!)
        
        self.secret = otpInfo.secret!.base32DecodedData!
        
        self.totp = TOTP(secret: self.secret, digits: Int(otpInfo.digits), timeInterval: Int(otpInfo.period), algorithm: .sha1)!
        let now = Int32(Date().timeIntervalSince1970)
        
        _interval = State(initialValue: Int(otpInfo.period-now%otpInfo.period))
                          
        _number = State(initialValue: (self.totp.generate(secondsPast1970: Int(now)))!)
    }
    
    let timer = Timer.publish(every: 1, tolerance: 0, on: .main, in: .common).autoconnect()

    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(otpInfo.issuer!).font(.title3)
                Spacer()
                Text("2021/02/02 10:48")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Text(number)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .onReceive(timer, perform: {
                    time in
                        if(interval==otpInfo.period){
                            number = (self.totp.generate(secondsPast1970:  Int(Date().timeIntervalSince1970)))!
                        }
                    
                })
            HStack{
                Text(otpInfo.email!)
                    .foregroundColor(.gray)
                Spacer()
                Text(interval.formatted()+"s")
                    .foregroundColor(.gray)
                    .onReceive(timer, perform: {
                        time in
                            if(interval == 0){
                                interval = Int(otpInfo.period)
                            }else{
                                interval-=1
                            }
                    })
            }
        }.padding(.all)
    }
}

struct OtpRow_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        OtpRow(otpInfo: OtpInfo())
    }
    
    func getOtp()->OtpInfo{
        let opt = OtpInfo()
        opt.username = "123"
        opt.created = Date()
        return opt
    }
}
