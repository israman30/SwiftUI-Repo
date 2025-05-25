import SwiftUI
import Combine

struct TimerModifier: ViewModifier {
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private let perform: (Date) -> Void
    
    init(every interval: TimeInterval, tolerance: TimeInterval?, perform: @escaping (Date) -> Void) {
        self.timer = Timer.publish(every: interval, tolerance: tolerance, on: .main, in: .common).autoconnect()
        self.perform = perform
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(timer) { date in
                self.perform(date)
            }
    }
}

extension View {
    func onTimer(every interval: TimeInterval, tolerance: TimeInterval? = nil, perform: @escaping (Date) -> Void) {
        self.modifier(
            TimerModifier(every: interval, tolerance: tolerance, perform: perform)
        )
    }
}
