//
//  ContentView.swift
//  HiOtp Watch App
//
//  Created by NAW on 2022/7/1.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        OtpList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
