//
//  NetworkRequest.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 19/03/2024.
//

import Foundation
import ObjectMapper
import Alamofire
import RxSwift

protocol NetworkRequestType {
    var request:       RequestData { get }
    var identifier:    String      { get }
    var logDispatch:   Bool        { get }
    var logResponse:   Bool        { get }
    
    typealias Headers    = Dictionary<String, String>
    typealias Parameters = Dictionary<String, Any?>
}

extension NetworkRequestType {
//    API Calls
    func apiCall<T: Mappable>(model: T.Type, showError: Bool = true) -> Single<T> {
        return self
            .rx_dispatch()
            .mapObject(T.self)
    }
    
    func apiCall<T: Mappable>(modelArray: T.Type, showError: Bool = true) -> Single<[T]> {
        return self
            .rx_dispatch()
            .mapArray(T.self)
    }

//    API Logger
    private func logMessage(_ message: String) {
        let separator = "-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-"
        
        print(separator)
        print(message)
        print(separator + "\n")
    }

    func logDispatchIfNeeded() {
        #if DEBUG
        var message = "\(request.method.rawValue.capitalized) - \(identifier)"
        
        if logDispatch {
            message.append("\n\tDomain: ")
            message.append(contentsOf: request.path)
            
            if let headersStr = getJSONString(from: request.headers) {
                message.append("\n\tHeaders: ")
                message.append(contentsOf: headersStr)
            }

            if let parametersStr = getJSONString(from: request.parameters) {
                message.append("\n\tParameters: ")
                message.append(contentsOf: parametersStr)
            }
        }
        
        logMessage(message)
        #endif
    }

    func logResponseIfNeeded(_ response: AFDataResponse<Any>) {
        #if DEBUG

        let status     = response.isValidStatusCode ? "Success" : "Error"
        let statusCode = response.response?.statusCode ?? -1
        let duration   = String(format: "%0.4f", response.metrics?.taskInterval.duration ?? "") + "s"

        var message = "\(request.method.rawValue.capitalized) - \(identifier) - \(status) - \(duration) - \(statusCode)"

        if logResponse {
            if let responseStr = getJSONString(from: response.value) {
                message.append("\n\tResponse: ")
                message.append(responseStr)
            }else if let data = response.data, let dataString = String(data: data, encoding: .utf8){
                message.append("\n\tResponse:Obj: ")
                message.append(String(describing: response.response))
                message.append("\n\tResponse: ")
                message.append(dataString)
            }
        }

        logMessage(message)
        #endif
    }

    private func getJSONString(from object: Any?) -> String? {
        guard
            let object = object,  JSONSerialization.isValidJSONObject(object),
            let prettyData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
            let str = String(data: prettyData, encoding: .utf8), str != "{\n\n}"
        else { return nil }
    
        return str
            .replacingOccurrences(of: "\n", with: "\n\t")
            .replacingOccurrences(of: "  ", with: "\t")
            .replacingOccurrences(of: " : ", with: "\t: ")
    }
}

struct RequestData {
    let path:       String
    let method:     HTTPMethod
    let headers:    [String : String]
    let parameters: [String : Any?]
    
    init(endpoint: String, method: HTTPMethod = .get, headers: [String : String] = [:],
         parameters: [String: Any?] = [:], authenticated: Bool = false) {

        self.path    = Requests.apisBaseURL + endpoint
        self.method  = method
        self.headers    = headers
        self.parameters = parameters
    }
    
    func getEncoding() -> ParameterEncoding {
        if method == .get || method == .delete {
            return URLEncoding(boolEncoding: .literal)
        } else {
            return JSONEncoding.default
        }
    }
}

extension NetworkRequestType {
    private func getRequest(onResult: @escaping (Swift.Result<Any, Error>) -> Void) -> DataRequest {
        
        logDispatchIfNeeded()
        
        return AF
            .request(
                request.path, method: request.method, parameters: request.parameters.cleanNulls(),
                encoding: request.getEncoding(), headers: HTTPHeaders(request.headers))
            .customValidation()
            .responseJSON { (res: AFDataResponse) in
                self.logResponseIfNeeded(res)

                if let error = res.error {
                    onResult(.failure(error))
                    return
                }

                guard let value = res.value else {
                    onResult(.failure(AppError.emptyResponse))
                    return
                }

                onResult(.success(value))
            }
//            .responseDecodable(
//                of: model.self,
//                completionHandler: { [weak self] (res: DataResponse) in
//                    self?.logResponseIfNeeded(res)
//                    
//                    if let value = res.value {
//                        onResult(.success(value))
//                    } else if let error = res.error {
//                        onResult(.failure(error))
//                    } else {
//                        onResult(.failure(AppError.unhandled))
//                    }
//                }
//            )
    }
    
    func rx_dispatch() -> Observable<Any> {
        return Observable<Any>.create({ (observer) -> Disposable in
            let request = getRequest(onResult: { (result) in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create {
                request.cancel()
            }
        })
    }
}

extension DataResponse {
    var isValidStatusCode: Bool {
        guard let statusCode = response?.statusCode else { return false }
        return (200...299).contains(statusCode)
    }
}

extension DataRequest {
    func customValidation() -> Self {
        return validate { request, response, data -> Request.ValidationResult in
            if (200...299).contains(response.statusCode) {
                return .success(())
            } else {
                guard let data = data else { return .failure(AppError.emptyResponse) }

                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?] {
                    if let errorStr = json["error"] as? String {
                        return .failure(AppError(errorStr))
                    } else if let errorStr = json["message"] as? String {
                        return .failure(AppError(errorStr))
                    } else {
                        return .failure(DDUnhandledNetworkingError(json))
                    }
                }

                if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any?]],
                   let json = jsonArray.first {
                    if let errorStr = json["error"] as? String {
                        return .failure(AppError(errorStr))
                    } else if let errorStr = json["message"] as? String {
                        return .failure(AppError(errorStr))
                    } else {
                        return .failure(DDUnhandledNetworkingError(json))
                    }
                }

                return .failure(AppError.invalidStatusCode)
            }
        }
    }
}
