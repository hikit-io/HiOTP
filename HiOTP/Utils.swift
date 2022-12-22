//
//  Utils.swift
//  HiOTP
//
//  Created by Nekilc on 2022/12/22.
//

#if canImport(AppKit)
import AppKit
#endif

func copyToPastboard(str:String){
#if os(iOS)
    UIPasteboard.general.string = str
#endif
#if os(macOS)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(str, forType: .string)
#endif
}
