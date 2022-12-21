//
//  Debug.swift
//  HiOTP
//
//  Created by Nekilc on 2022/12/21.
//

import SwiftUI

struct Debug: View {
    
    var body: some View {
        Form{
            NavigationLink("Add OTP"){
                AddOtp()
            }
        }
    }
    
    struct Debug_Previews: PreviewProvider {
        static var previews: some View {
            Debug()
        }
    }
    
}
