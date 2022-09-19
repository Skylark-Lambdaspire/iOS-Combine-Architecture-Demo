
import SwiftUI

struct Bootstapper : View {
    
    @State private(set) var container: Container!
    
    var body: some View {
        if let _ = container {
            ContentView()
        } else {
            Text("Initialising...")
                .onAppear {
                    container = IoC.configure()
                }
        }
    }
}
