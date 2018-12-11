import Action
import Result
import RxSwift
extension Action {
    var result: Observable<T> {
        return Observable<U>.create { [weak self] observer -> Disposable in
            guard let me = self else {
                return Disposables.create()
            }
            let success = me.elements
                .map { .success($0) }
                .bind(to: observer)
            let error = me.errors
                .map { .failure($0) }
                .bind(to: observer)
            return Disposables.create {
                success.dispose()
                error.dispose()
            }
        }
    }
    func foo() -> Observable<T> {
        self.doSomething()
        let request = Request()
        return apiSession
            .send(request)
            .do(onError: { [weak self] error in
                guard let me = self else { return }
                me.dispatch(error)
            })
            .do(onError: { [weak self] error in
                guard let me = self else { return }
                me.dispatch(error)
                me.dispatch(error)
            })
    }
}
