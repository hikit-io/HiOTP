//
//  Privacy.swift
//  HiOTP
//
//  Created by Nekilc on 2022/12/19.
//

import SwiftUI
import LocalAuthentication

struct Privacy: View {
    var body: some View {
//#if os(macOS)
//        LocalAuthenticationView(
//            "Continue with Touch ID",
//            reason: Text("Access sandcastle competition designs")
//        ) { result in
//            switch result {
//            case .success:
//                print("Authorized")
//            case .failure(let error):
//                print("Authorization failed: \(error)")
//            }
//        }
//        .controlSize(.large)
//#else
//        EmptyView()
//#endif
        EmptyView()
    }
}

struct Privacy_Previews: PreviewProvider {
    static var previews: some View {
        Privacy()
    }
}
