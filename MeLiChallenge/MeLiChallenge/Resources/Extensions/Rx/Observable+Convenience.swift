//
//  Observable+Convenience.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 20/03/2024.
//

import Foundation
import ObjectMapper
import RxSwift

extension Observable where Element: Any {
    func mapObject<T : Mappable>(_ type: T.Type) -> Single<T> {
        let mapper = Mapper<T>()
        
        return self.map { (element) -> T in
            guard let parsedElement = mapper.map(JSONObject: element) else {
                throw AppError.parsingError
            }
            
            return parsedElement
        }.asSingle()
    }
    
    func mapArray<T : Mappable>(_ type: T.Type) -> Single<[T]> {
        let mapper = Mapper<T>()
        
        return self.map { (element) -> [T] in
            guard let parsedArray = mapper.mapArray(JSONObject: element) else {
                throw AppError.parsingError
            }

            return parsedArray
        }.asSingle()
    }
        
    func discardResult() -> Observable<Void> {
        return self.map(discardObservableResult)
    }
    
    fileprivate func discardObservableResult<T>(_ arg: T) -> Void {
        return
    }
}
