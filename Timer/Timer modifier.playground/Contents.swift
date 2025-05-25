import SwiftUI
import Combine

struct TimerModifier: ViewModifier {
    
    typealias PerformanceClosure = (Date) -> Void
    
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let cancelTrigger: AnyHashable?
    private let perform: PerformanceClosure
    
    init(every interval: TimeInterval, tolerance: TimeInterval?, cancelTrigger: AnyHashable?, perform: @escaping PerformanceClosure) {
        self.timer = Timer.publish(every: interval, tolerance: tolerance, on: .main, in: .common).autoconnect()
        self.cancelTrigger = cancelTrigger
        self.perform = perform
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(timer) { date in
                self.perform(date)
            }
            .onChange(of: cancelTrigger) { _, _ in
                self.timer.upstream.connect().cancel()
            }
    }
}

extension View {
    typealias PerformanceClosure = (Date) -> Void
    
    func onTimer(every interval: TimeInterval, tolerance: TimeInterval? = nil, cancelTrigger: AnyHashable? = nil, perform: @escaping PerformanceClosure) -> some View {
        self.modifier(
            TimerModifier(every: interval, tolerance: tolerance, cancelTrigger: cancelTrigger, perform: perform)
        )
    }
}

// usage
var currentDate = Date()

Text(Date.now.formatted(date: .numeric, time: .standard))
    .onTimer(every: 1, tolerance: 0.05) { date in
        currentDate = date
    }

// usage in view
struct MyView: View {
    @State private var currentDate = Date.now
    @State private var cancelTimer = false
    
    var body: some View {
        VStack {
            Text(Date.now.formatted(date: .numeric, time: .standard))
            Button("Stop Timer") {
                cancelTimer = true
            }
        }
        .onTimer(every: 1, cancelTrigger: cancelTimer) { date in
            currentDate = date
        }
    }
}


