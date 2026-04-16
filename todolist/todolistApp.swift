import SwiftUI
import SwiftData

@main
struct todolistApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Todo.self) // 👈 BÜYÜLÜ SATIR
    }
}

