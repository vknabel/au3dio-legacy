
public protocol Au3dioModulePlugin {
    var module: Au3dioModule { get }
    init(module: Au3dioModule)
}

public protocol Au3dioInteractorType: Au3dioModulePlugin { }
public protocol Au3dioPresenterType: Au3dioModulePlugin { }
