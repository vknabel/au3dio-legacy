
import AccessOperator

struct AccessComponent<T: ComponentType>: AccessOperator {
    typealias Target = ComponentDictionaryType
    typealias Argument = T
    typealias Result = T

    let argument: Argument
    init(argument: Argument) {
        self.argument = argument
    }

    func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void {

    }
}
struct AccessIndex: AccessOperator {
    typealias Target = ListComponentType
    typealias Argument = Int
    typealias Result = CompositionType

    let argument: Argument
    init(argument: Argument) {
        self.argument = argument
    }

    func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void {
        var result: Result? = target?.children[argument]
        withAccess(result: &result)
        if let result: Result = result {
            target?.children[argument] = result
        } else {
            target?.children.removeAtIndex(argument)
        }
    }
}
struct AccessKey: AccessOperator {
    typealias Target = ComponentDictionaryType
    typealias Argument = String
    typealias Result = ComponentType

    let argument: Argument
    init(argument: Argument) {
        self.argument = argument
    }

    func update(inout target: Target?, withAccess: (inout result: Result?) -> Void) -> Void {
        var result = target?.components[argument]
        withAccess(result: &result)
        if let result = result {
            target?.components[argument] = result
        } else {
            target?.components.removeValueForKey(argument)
        }
    }
}