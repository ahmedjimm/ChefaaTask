

import Foundation

enum AppError: Error, Equatable {
    case offline
    case networkError
    case notFound
    case with(message: String)
    case empty
    case timeout
    case unauthorized
    case badRequest
    case serverError(error:String = "server Error")
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .offline:
            return ""
        case .networkError:
            return ""
        case .notFound:
            return ""
        case .with(let message):
            return ""
        case .empty:
            return ""
        case .timeout:
            return ""
        case .unauthorized:
            return ""
        case .badRequest:
            return ""
        case .serverError(let error):
            return error
        }
    }
}
