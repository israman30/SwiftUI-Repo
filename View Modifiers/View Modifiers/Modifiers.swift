//
//  Modifiers.swift
//  View Modifiers
//
//  Created by Israel Manzo on 11/12/24.
//

import SwiftUI

// MARK: - Heading Modifier -
struct Heading1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Baloo2-ExtraBold", size: 24))
    }
}

extension View {
    public func heading1() -> some View {
        modifier(Heading1())
    }
}

// MARK: - Card Shadow Modifer -
struct CardShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.16), radius: 12)
    }
}

extension View {
    public func cardShadow() -> some View {
        modifier(CardShadow())
    }
}

// MARK: - Layout Modifer -
struct AlignModifier: ViewModifier {
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

struct AlignTextModifier: ViewModifier {
    let alignment: Alignment
    let textAlignment: TextAlignment
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: alignment)
            .multilineTextAlignment(textAlignment)
    }
}

extension View {
    func alignView(_ alignment: Alignment) -> some View {
        modifier(AlignModifier(alignment: alignment))
    }
    
    func alignText(_ alignment: Alignment, textAlignment: TextAlignment) -> some View {
        modifier(AlignTextModifier(alignment: alignment, textAlignment: textAlignment))
    }
    
    func fullWidth() -> some View {
        frame(maxWidth: .infinity)
    }
}

// MARK: - `if` modifier
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: @autoclosure() -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Presentation Modifier -
extension View {
    public func popUp<V>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> V
    ) -> some View where V: View {
        self
            .blur(radius: isPresented.wrappedValue ? 4 : 0.0)
            .overlay {
                if isPresented.wrappedValue {
                    ZStack {
                        Color(.gray)
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.8)
                            .onTapGesture {
                                isPresented.wrappedValue = false
                            }
                        VStack {
                            Spacer()
                            content()
                            Spacer()
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height)
                }
            }
    }
}

// MARK: - Animation Modifier -
struct PulseAnimation: ViewModifier {
    @State private var animatePulse = false
    
    func body(content: Content) -> some View {
        content
            .opacity(animatePulse ? 0.5 : 1)
            .scaleEffect(animatePulse ? 1.3 : 1)
            .onAppear {
                withAnimation(.bouncy(duration: 0.5).repeatForever()) {
                    animatePulse.toggle()
                }
            }
    }
}
extension View {
    public func pulseAnimation() -> some View {
        modifier(PulseAnimation())
    }
}

struct ShadowCustomButton: ButtonStyle {
    var shadowColor: Color = .black
    var shadowRadius: CGFloat = 10.0
    var xShadow: CGFloat = 0.0
    var yShadow: CGFloat = 5.0
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
            .shadow(
                color: configuration.isPressed ? shadowColor.opacity(0.4) : shadowColor.opacity(0.8),
                radius: configuration.isPressed ? shadowRadius / 2 : shadowRadius,
                x: xShadow, y: yShadow
            )
            .scaleEffect(configuration.isPressed ? 0.09 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ShadowCustomButton {
    static var shadow: ShadowCustomButton { ShadowCustomButton() }
}


// MARK: - Label View Implementation -
protocol LabelViewContent {
    associatedtype Content: View
    @ViewBuilder
    var content: Content { get }
}

struct LabelView: View {
    private let text: String
    private let icon: String?
    
    init(text: String, icon: String? = nil) {
        self.text = text
        self.icon = icon
    }
    
    var body: some View {
        HStack {
            if let icon {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 16)
            }
            
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(Color.gray.opacity(0.2))
        )
    }
}

struct CustomLabelView<Content: LabelViewContent>: View {
    var labelViewContent: Content
    
    init(_ labelViewContent: Content) {
        self.labelViewContent = labelViewContent
    }
    
    var body: some View {
        labelViewContent
            .content
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color.gray.opacity(0.2))
            )
    }
}

struct TextLabelViewContentView: LabelViewContent {
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var content: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
    }
}

struct TextIconLeftLabelView: LabelViewContent {
    private let text: String
    private let icon: Image
    
    init(text: String, icon: Image) {
        self.text = text
        self.icon = icon
    }
    
    var content: some View {
        HStack {
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 16)
            
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

struct TextWithLeftRightIconContent: LabelViewContent {
    private let text: String
    private let leftIcon: Image
    private let rightIcon: Image
    
    init(text: String, leftIcon: Image, rightIcon: Image) {
        self.text = text
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }
    
    var content: some View {
        HStack {
            leftIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 16)
            
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
            
            rightIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 16)
        }
    }
}
