
import SwiftUI

struct TextPromptView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    
    var title: String
    var message: String
    var placeholder: String
    var onCommit: (String) -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TextPromptView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TextPromptView>) {
        
        guard context.coordinator.alert == nil else { return }
        
        if isPresented {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            context.coordinator.alert = alert
            
            alert.addTextField { textField in
                textField.placeholder = placeholder
                textField.delegate = context.coordinator
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.dismiss(animated: true) {
                    isPresented = false
                    context.coordinator.alert = nil
                }
            })
            
            let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
                onCommit(alert.textFields!.first!.text!)
                alert.dismiss(animated: true) {
                    isPresented = false
                    context.coordinator.alert = nil
                }
            }
            doneAction.isEnabled = false
            alert.addAction(doneAction)
            
            uiViewController.present(alert, animated: true)
        }
    }
    
    func makeCoordinator() -> TextPromptView.Coordinator {
        .init()
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var alert: UIAlertController?
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            // Disable the alert's "Done" action if the text is (going to be) empty.
            // Assume's the "Done" action is the last one.
            
            let textFieldRange = NSRange(location: 0, length: textField.text?.count ?? 0)
            
            alert?.actions.last!.isEnabled = !(
                NSEqualRanges(range, textFieldRange) &&
                string.isEmpty
            )
            
            return true
        }
    }
}

extension View {
    func textPrompt(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        placeholder: String? = nil,
        onCommit: @escaping (String) -> Void) -> some View {
            
            background(TextPromptView(
                isPresented: isPresented,
                title: title,
                message: message,
                placeholder: placeholder ?? "",
                onCommit: onCommit))
        }
}
