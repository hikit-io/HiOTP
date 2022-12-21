//
//  OtpList.swift
//  HiOTP
//
//  Created by NAW on 2022/7/1.
//

import SwiftUI
import CoreData

#if canImport(UIKit)
import UIKit
#endif


#if canImport(AppKit)
import AppKit
#endif


#if canImport(CoreImage)
import CoreImage
import CoreImage.CIFilterBuiltins
#endif

import EFQRCode


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
    
    @State var tick:Int64 = 0
    
    @State var showQrSheet = false
    @State var qrSheetData = ""
    
    init(onItemClick:@escaping ()->Void) {
        self.onItemClick = onItemClick
    }
    
    let listColor = {
#if os(iOS)
        Color(uiColor: .tertiarySystemBackground)
#elseif os(macOS)
        Color(nsColor: .textBackgroundColor)
#else
        Color(.darkGray)
#endif
    }()
    
    struct BottomBorder: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            
            return path
        }
    }
    
#if os(iOS)
    let separatorColor = Color(uiColor: .separator)
    let listStyle:GroupedListStyle = GroupedListStyle()
#elseif os(macOS)
    let separatorColor = Color(nsColor: .systemGray)
    let listStyle:PlainListStyle = PlainListStyle()
#else
    //        let listColor = Color(.black)
    let separatorColor = Color(uiColor: .darkGray)
    let listStyle:CarouselListStyle = CarouselListStyle()
#endif
    
    
    func listRowBackground()->some View{
#if !os(watchOS)
        Rectangle()
            .foregroundColor(listColor)
            .overlay(BottomBorder().stroke(separatorColor,lineWidth: 1))
#else
        RoundedRectangle(cornerRadius: 11)
            .foregroundColor(listColor)
#endif
    }
    
    var body: some View {
        List{
            ForEach(items){otp in
                OtpRow(otpInfo: otp,tick: $tick) {
                    onItemClick()
                }
                .listRowBackground(listRowBackground())
                .swipeActions(edge: .leading) {
                    Button {
                        showQrSheet = true
                        qrSheetData = otp.secret ?? ""
                    } label: {
                        Label("qrcode", systemImage: "qrcode")
                    }.tint(.blue)
                }
#if os(macOS)
                .contextMenu {
                    Button("ctx_menu_as_main_screen", action: {})
                }
#endif
#if os(iOS) || os(macOS)
                .listRowSeparator(.hidden)
#endif
            }.onDelete { index in
                deleteItems(offsets: index)
            }.onReceive(timer) { tim in
                tick += 1
            }
        }
        .listStyle(listStyle)
        .sheet(isPresented: $showQrSheet) {
            QRCodeImage(data: qrSheetData)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    struct QRCodeImage:View{
        var data:String
        init(data: String) {
            self.data = data
        }
        var body: some View{
            guard let cgiImage = EFQRCode.generate(for: self.data) else{
                return AnyView(EmptyView())
            }
            let Image = Image(cgiImage, scale: 1, label: Text("")).interpolation(.none)
#if !os(watchOS)
            return AnyView(
                NavigationStack(root: {
                    Image
                        .resizable()
                        .scaledToFit()
                        .navigationTitle(Text("qrcode"))
                        .frame(minWidth: 100,minHeight: 100)
                })
            )
#else
            return AnyView(
                Image
                    .resizable()
                    .scaledToFit()
                    
            )
#endif
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
