
import SwiftUI

struct SignInScreen : View {
    
    @StateObject private var vm: SignInScreenViewModel = .init()
    
    var body: some View {
        Form {
            Section(
                header: Header(),
                footer: Footer()) {
                    TextField(text: $vm.username) {
                        Text("Username")
                    }
                    SecureField(text: $vm.password) {
                        Text("Password")
                    }
            }
        }
        .background(ZStack {
            TodosScreenNavigation()
        })
        .navigationTitle("Sign In")
        .onDisappear {
            vm.username = ""
            vm.password = ""
        }
    }
    
    @ViewBuilder private func Header() -> some View {
        Text("Sign into our insecure server")
    }
    
    @ViewBuilder private func Footer() -> some View {
        Button(action: vm.signIn) {
            Label("Sign In", systemImage: "lock")
                .font(.body)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(vm.username.isEmpty || vm.password.isEmpty)
    }
    
    @ViewBuilder private func TodosScreenNavigation() -> some View {
        NavigationLink(
            "",
            isActive: .init(
                get: { vm.isAuthenticated },
                set: { v in
                    if !v { vm.signOut() }
                })) {
                    TodosScreen()
                }
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        StandardPreviews {
            NavigationView {
                SignInScreen()
            }
        }
        .standardPreviewsEnvironment()
    }
}
