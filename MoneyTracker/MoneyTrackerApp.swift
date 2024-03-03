//
//  MoneyTrackerApp.swift
//  MoneyTracker
//
//  Created by Vishal Kashyap on 03/03/24.
//

import SwiftUI
import SwiftData

@main
struct MoneyTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Expense.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Data persisted in container.
        .modelContainer(sharedModelContainer)
        // (or)
        // .modelContainer(for: [Expense.self])
    }
}
