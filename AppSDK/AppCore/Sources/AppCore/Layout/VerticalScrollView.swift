import SwiftUI

public struct VerticalScrollView<Content: View>: View {
    public enum AlignmentStyle {
        case top
        case center
    }

    let alignment: AlignmentStyle
    let content: (_ proxy: ScrollViewProxy) -> Content

    public init(
        alignment: AlignmentStyle,
        content: @escaping (_ proxy: ScrollViewProxy) -> Content
    ) {
        self.alignment = alignment
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    Group {
                        switch alignment {
                        case .top:
                            content(proxy)
                                .frame(maxWidth: .infinity)
                        case .center:
                            ZStack {
                                Color.clear
                                    .frame(height: geometry.size.height)
                                content(proxy)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    VerticalScrollView(alignment: .center) { _ in
        Text("Hello World!")
    }
}
