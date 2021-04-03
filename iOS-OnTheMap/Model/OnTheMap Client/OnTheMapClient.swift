//
//  OnTheMapClient.swift
//  iOS-OnTheMap
//
//  Created by Anupam Beri on 02/04/2021.
//

import Foundation

class OnTheMapClient {
    
    struct Auth {
        static var uniqueKey = ""
        static var sessionId = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case getStudentLocation
        case createSessionId
        case updateStudentLocation(String)
        
        var stringValue: String {
            switch self {
            
                case .getStudentLocation: return Endpoints.base + "StudentLocation"
            
                case .createSessionId: return Endpoints.base + "session"
                    
                case .updateStudentLocation(let objectId): return Endpoints.base + objectId
            }
            
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getRecentStudentLocations(completion: @escaping ([StudentInformation], Error?) -> Void) {
        let urlBase = URL(string: Endpoints.getStudentLocation.stringValue)!
        let urlQueryItems = [URLQueryItem(name: "limit", value: "100"),
                             URLQueryItem(name: "order", value: "-updatedAt")]
        let urlWithQueryItems = urlBase.appending(urlQueryItems)!
        taskForGETRequest(url: urlWithQueryItems, response: StudentsInformation.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postNewStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (String?, String?, Error?) -> Void) {
        let studentInformation = StudentInformation(firstName: firstName, lastName: lastName, longitude: longitude, latitude: latitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: Auth.uniqueKey, objectId: nil, createdAt: nil, updatedAt: nil)
        
        var request = URLRequest(url: Endpoints.getStudentLocation.url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(studentInformation)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(PostStudentLocationResponse.self, from: data)
                Auth.objectId = responseObject.objectId
                DispatchQueue.main.async {
                    completion(responseObject.createdAt, responseObject.objectId, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func updateStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, objectId: String, completion: @escaping (String?, Error?) -> Void) {
        let studentInformation = StudentInformation(firstName: firstName, lastName: lastName, longitude: longitude, latitude: latitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: Auth.uniqueKey, objectId: nil, createdAt: nil, updatedAt: nil)
        
        var request = URLRequest(url: Endpoints.updateStudentLocation(objectId).url)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(studentInformation)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(UpdateStudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.updatedAt, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let udacityCredentials = UdacityCredentials(username: username, password: password)
        let postSessionRequest = PostSessionRequest(udacity: udacityCredentials)
        
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(postSessionRequest)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            // Ignore the first 5 characters
            let decoder = JSONDecoder()
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            
            do {
                let responseObject = try decoder.decode(PostSessionResponse.self, from: newData)
                // Set Authentication parameters
                Auth.uniqueKey = responseObject.account.key
                Auth.sessionId = responseObject.session.id
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(PostSessionErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, error)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, response: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
