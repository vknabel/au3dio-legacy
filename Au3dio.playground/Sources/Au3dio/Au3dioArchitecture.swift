
public protocol Au3dioModulePart {
    var module: Au3dioModule { get }
    init(module: Au3dioModule)
}

public protocol Au3dioInteractorType: Au3dioModulePart { }
public protocol Au3dioPresenterType: Au3dioModulePart { }
