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
    
    // callback
    private var onItemClick:()->Void
    // timer
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var tick:Int64 = 0;
    
    init(onItemClick:@escaping ()->Void) {
        self.onItemClick = onItemClick
    }
    
    var body: some View {
        List{
            ForEach(items){otp in
                OtpRow(otpInfo: otp,tick: $tick) {
                    onItemClick()
                }
            }.onDelete { index in
                deleteItems(offsets: index)
            }.onReceive(timer) { tim in
                tick += 1
            }
        }
#if os(iOS)
        .listStyle(.sidebar)
#endif
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct OtpList_Previews: PreviewProvider {
    static var previews: some View {
        OtpList(onItemClick: {
            
        })
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
