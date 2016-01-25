
import StateMachine
import Then

extension StateMachine: Then { }

extension StateFlow {
    /// Adds transitions assotiatively.
    /// allow(from: states, to: states, filter: filter)
    public mutating func allowAssociatively(states: [T], filter: TransitionFilter? = nil) {
        allow(from: states, to: states, filter: filter)
    }

}