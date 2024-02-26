

import RxSwift
import Moya
import Foundation

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    func catchAppError() -> Single<Element> {
        return flatMap { response in
            switch response.statusCode {
            case 204:
                throw AppError.empty
            case 200...299:
                return .just(response)
            case 400:
                throw AppError.badRequest
            case 401,403,405,409:
                throw AppError.unauthorized
            case 404:
                throw AppError.notFound
            case 408, -1001:
                throw AppError.timeout
            case 500:
                throw AppError.serverError(error: "server error")
            default:
                throw AppError.networkError
            }
        }
    }
}

