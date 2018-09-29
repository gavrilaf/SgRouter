import Foundation

public enum RouterError: Error, Equatable {
    case duplicatedWildcard(String)
    case notFound(String)
}
