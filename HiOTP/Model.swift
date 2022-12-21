//
//  Model.swift
//  HiOTP
//
//  Created by Nekilc on 2022/12/21.
//

import SwiftUI


public extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
