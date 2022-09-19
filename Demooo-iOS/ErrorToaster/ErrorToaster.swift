
import SwiftUI

struct ErrorToaster : View {
    
    @StateObject private var vm: ErrorToasterViewModel = .init()
    
    var body: some View {
        VStack {
            Spacer()
            ForEach(vm.errorMessages, id: \.self) { e in
                VStack {
                    HStack {
                        Spacer()
                        Label(e, systemImage: "exclamationmark.triangle.fill")
                            .padding()
                            .foregroundColor(.white)
                            .background(.red)
                    }
                }
            }
        }
        .padding()
        .allowsHitTesting(false)
    }
}

struct ErrorToaster_Previews: PreviewProvider {
    static var previews: some View {
        StandardPreviews {
            ZStack {
                NavigationView {
                    
                    Button(action: {
                        (Container.shared.resolve() as ErrorContext).push(errorMessage: "PREVIEW ERROR MESSAGE")
                    }) {
                        Text("Test")
                    }
                    .navigationTitle("Hello")
                }
                ErrorToaster()
            }
        }
        .standardPreviewsEnvironment()
    }
}
