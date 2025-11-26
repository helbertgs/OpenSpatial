import Foundation

public enum Error : Swift.Error {
    case outOfRage
}

extension Error  {
    public var localizedDescription: String {
        "Index out of range. Valid indices are 0, 1, and 2."
    }
}