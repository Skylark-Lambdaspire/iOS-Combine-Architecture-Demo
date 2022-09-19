
import SwiftUI

struct TodoComponent : View {
    
    var todo: Todo
    var onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            Label {
                Text(todo.name)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: todo.done
                    ? "checkmark.circle.fill"
                      : "circle")
            }

        }
    }
}

struct TodoComponent_Previews: PreviewProvider {
    
    @State static var todos: [Todo] = [
        .init(id: .init(), name: "Preview 1", done: false),
        .init(id: .init(), name: "Preview 2", done: true),
        .init(id: .init(), name: "Preview 3 VERY LONG WOW SO LONG NAME WOW SUCH VERY VERY LONG", done: false)
    ]
    
    static var previews: some View {
        StandardPreviews {
            NavigationView {
                List {
                    ForEach(todos, id: \.id) { t in
                        TodoComponent(
                            todo: t,
                            onToggle: { })
                    }
                }
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
