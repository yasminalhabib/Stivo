//
//  StivoApp.swift
//  Stivo
//
//  Created by Yasmin Alhabib on 03/02/2026.
//

import SwiftUI

@main
struct StivoApp: App {

    init() {
        NotificationManager.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
