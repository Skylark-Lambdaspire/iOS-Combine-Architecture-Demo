
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            NavigationView {
                SignInScreen()
            }
            ErrorToaster()
        }
    }
}
