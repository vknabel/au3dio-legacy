
/// All modules should implement this protocol.
public protocol ModuleType { }
/// All interactors need to implement this protocol.
public protocol InteractorType {
    /// The target module type.
    /// All requirements should be provided by the module.
    typealias Module: ModuleType
    /// The module the interactor was created with.
    var module: Module { get }
    /// Creates a new interactor.
    init(module: Module)
}
/// All presenters should implement this protocol.
public protocol PresenterType {
    /// The target module type.
    /// All requirements should be provided by the module.
    typealias Module: ModuleType
    /// The module the presenter was created with.
    var module: Module { get }
    /// Creates a new presenter.
    init(module: Module)
}