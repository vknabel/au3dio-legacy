
import AccessOperator

public struct AccessComponent<T: ComponentType>: AccessOperator {
    public typealias Target = ComponentDictionaryType
    public typealias Argument = T
    public typealias Result = T

    public init(type: Argument.Type? = nil) {
    }

    public func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void {

    }
}

public extension AccessOperator where Self.Result == ComponentDictionaryType {
    public func component<C: ComponentType>(type: C.Type? = nil) -> AnyAccessOperator<Target, C> {
        return self.chaining(AccessComponent<C>())
    }
}

public struct AccessIndex: AccessOperator {
    public typealias Target = ListComponentType
    public typealias Argument = Int
    public typealias Result = CompositionType

    public let argument: Argument
    public init(argument: Argument) {
        self.argument = argument
    }

    public func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void {
        var result: Result? = target?.children[argument]
        withAccess(result: &result)
        if let result: Result = result {
            target?.children[argument] = result
        } else {
            target?.children.removeAtIndex(argument)
        }
    }
}

public extension AccessOperator where Self.Result == ListComponentType {
    public func composition(index: Int) -> AnyAccessOperator<Target, CompositionType> {
        return self.chaining(AccessIndex(argument: index))
    }
}

public struct AccessKey: AccessOperator {
    public typealias Target = ComponentDictionaryType
    public typealias Argument = String
    public typealias Result = ComponentType

    public let argument: Argument
    public init(argument: Argument) {
        self.argument = argument
    }

    public func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void {
        var result = target?.components[argument]
        withAccess(result: &result)
        if let result = result {
            target?.components[argument] = result
        } else {
            target?.components.removeValueForKey(argument)
        }
    }
}

public extension AccessOperator where Self.Result == ComponentDictionaryType {
    public func component(key: String) -> AnyAccessOperator<Target, ComponentType> {
        return self.chaining(AccessKey(argument: key))
    }
}
