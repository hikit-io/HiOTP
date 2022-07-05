//
//  OtpList.swift
//  HiOTP
//
//  Created by NAW on 2022/7/1.
//

import SwiftUI
import CoreData

struct OtpList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \OtpInfo.created, ascending: true)],
        animation: .default)
    private var items: FetchedResults<OtpInfo>
    var body: some View {
        List{
            ForEach(items){otp in
                OtpRow(otpInfo: otp)
            }
        }
#if os(iOS)
        .listStyle(.sidebar)
#endif
    }
}

struct OtpList_Previews: PreviewProvider {
    static var previews: some View {
        OtpList()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
