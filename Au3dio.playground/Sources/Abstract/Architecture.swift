
public protocol ModuleType { }
public protocol InteractorType {
    typealias Module: ModuleType

    var module: Module { get }

    init(module: Module)
}

public protocol PresenterType {
    typealias Module: ModuleType

    var module: Module { get }

    init(module: Module)
}