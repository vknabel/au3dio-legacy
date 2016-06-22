
protocol AccessOperator {
    associatedtype Target
    associatedtype Result

    func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void
}

extension AccessOperator {
    func chaining<T: AccessOperator where T.Target == Self.Result>
        (access: T) -> ComposedAccessOperator<Self, T> {
        return ComposedAccessOperator(argument: (self, access))
    }
}

struct AnyAccessOperator<T, R>: AccessOperator {
    typealias Target = T
    typealias Result = R

    var updater: ((inout T?, (inout R?) -> Void) -> Void)
    init<O: AccessOperator where O.Target == T, O.Result == R>(of accessOperator: O) {
        self.updater = accessOperator.update
    }

    func update(inout target: T?, withAccess: (result: inout R?) -> Void) {
        self.updater(&target, withAccess)
    }
}

struct ComposedAccessOperator<T: AccessOperator, R: AccessOperator where T.Result == R.Target>: AccessOperator {
    typealias Target = T.Target
    typealias Argument = (T, R)
    typealias Result = R.Result

    let inputOperator: T
    let outputOperator: R
    init(argument: (T, R)) {
        (inputOperator, outputOperator) = argument
    }

    func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void {
        inputOperator.update(&target) { (result) in
            self.outputOperator.update(&result, withAccess: withAccess)
        }
    }
}
