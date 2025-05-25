import SwiftUI
import Combine

struct TimerModifier: ViewModifier {
    
    typealias PerformanceClosure = (Date) -> Void
    
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private let perform: PerformanceClosure
    
    init(every interval: TimeInterval, tolerance: TimeInterval?, perform: @escaping PerformanceClosure) {
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
    typealias PerformanceClosure = (Date) -> Void
    
    func onTimer(every interval: TimeInterval, tolerance: TimeInterval? = nil, perform: @escaping PerformanceClosure) {
        self.modifier(
            TimerModifier(every: interval, tolerance: tolerance, perform: perform)
        )
    }
}
