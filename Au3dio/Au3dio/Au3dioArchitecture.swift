
/// All plugins that need to be added to `Au3dioModule` need to implement this protocol.
public protocol Au3dioModulePlugin {
    /// References the `Au3dioModule`.
    var module: Au3dioModule { get }
    /// Initializes an `Au3dioModulePlugin` with a given `Au3dioModule`.
    init(module: Au3dioModule)
}

/// VIPER Interactors need to implement this protocol.
public protocol Au3dioInteractorType: Au3dioModulePlugin { }
/// VIPER Presenters need to implement this protocol.
public protocol Au3dioPresenterType: Au3dioModulePlugin { }
