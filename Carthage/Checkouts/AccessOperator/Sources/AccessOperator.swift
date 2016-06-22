
public protocol AccessOperator {
    associatedtype Target
    associatedtype Result

    func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void
}

public extension AccessOperator {
    public func chaining<T: AccessOperator where T.Target == Self.Result>
        (access: T) -> AnyAccessOperator<Target, T.Result> {
        let composed = ComposedAccessOperator(argument: (self, access))
        return AnyAccessOperator<Target, T.Result>(of: composed)
    }
}

public struct AnyAccessOperator<T, R>: AccessOperator {
    public typealias Target = T
    public typealias Result = R

    public let updater: ((inout T?, (inout R?) -> Void) -> Void)
    public init<O: AccessOperator where O.Target == T, O.Result == R>(of accessOperator: O) {
        self.updater = accessOperator.update
    }

    public func update(inout target: T?, withAccess: (result: inout R?) -> Void) {
        self.updater(&target, withAccess)
    }
}

public struct ComposedAccessOperator<T: AccessOperator, R: AccessOperator where T.Result == R.Target>: AccessOperator {
    public typealias Target = T.Target
    public typealias Argument = (T, R)
    public typealias Result = R.Result

    public let inputOperator: T
    public let outputOperator: R
    public init(argument: (T, R)) {
        (inputOperator, outputOperator) = argument
    }

    public func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void {
        inputOperator.update(&target) { (result) in
            self.outputOperator.update(&result, withAccess: withAccess)
        }
    }
}
