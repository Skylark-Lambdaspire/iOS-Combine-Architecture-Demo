
import SwiftUI

struct StandardPreviews<Content: View> : View {
    
    var light: Bool = true
    var dark: Bool = true
    var large: Bool = true
    var small: Bool = true
    
    var content: () -> Content
    
    var body: some View {
        Group {
            
            if light {
                content()
            }
            
            if dark {
                content()
                    .environment(\.colorScheme, .dark)
            }
            
            if large {
                content()
                    .environment(\.sizeCategory, .accessibilityExtraLarge)
            }
            
            if small {
                content()
                    .environment(\.sizeCategory, .extraSmall)
            }
        }
    }
}

struct StandardPreviews_Previews : PreviewProvider {
    static var previews: some View {
        StandardPreviews {
            Preview()
        }
        .previewLayout(.sizeThatFits)
    }
    
    struct Preview : View {
        var body: some View {
            VStack(spacing: 10) {
                Image(systemName: "face.smiling.fill")
                Text("Hello Previews.")
            }
            .foregroundColor(.accentColor)
            .padding()
            #if !os(tvOS)
            .background(Color(.systemBackground))
            #endif
        }
    }
}
