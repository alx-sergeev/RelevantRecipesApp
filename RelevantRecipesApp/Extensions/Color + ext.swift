//
//  Color + ext.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 23.01.2024.
//

import SwiftUI

protocol ColorThemeSettings {
    var accent: Color { get }
}

extension Color {
    static let theme: ColorThemeSettings = ColorTheme()
}

struct ColorTheme: ColorThemeSettings {
    let accent = Color("AccentColor")
}
