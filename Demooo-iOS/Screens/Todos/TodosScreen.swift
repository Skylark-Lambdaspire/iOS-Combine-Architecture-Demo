
import SwiftUI

struct TodosScreen : View {
    
    @StateObject private var vm: TodosScreenViewModel = .init()
    
    @State private var adding: Bool = false
    
    var body: some View {
        List {
            Section {
                ForEach(vm.todos, id: \.id) { todo in
                    TodoComponent(
                        todo: todo,
                        onToggle: { vm.toggle(todo) })
                }
            }
        }
        .refreshable(action: vm.refresh)
        .navigationTitle("Todos")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: add) {
                    Label("Add", systemImage: "plus")
                }
                .textPrompt(
                    isPresented: $adding,
                    title: "Name",
                    message: "Whatcha doin'?",
                    onCommit: commitAdd)
            }
        }
    }
    
    private func add() {
        adding = true
    }
    
    private func commitAdd(name: String) {
        vm.add(name)
    }
}

struct TodosScreen_Previews: PreviewProvider {
    static var previews: some View {
        StandardPreviews {
            NavigationView {
                TodosScreen()
            }
        }
        .standardPreviewsEnvironment()
    }
}
