

import Foundation
import RxSwift


extension Observable where Element: Any {
    
    func startLoadingOn(_ subject: PublishSubject<Bool>) -> Observable<Element> {
        return self.do(onNext: { _ in
            subject.onNext(true)
        })
    }
    
    func stopLoadingOn(_ subject: PublishSubject<Bool>) -> Observable<Element> {
        return self.do(onNext: { _ in
            subject.onNext(false)
        })
    }
}
