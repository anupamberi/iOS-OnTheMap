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
        
        case getOrPostStudentLocation
        case getCurrentUserPostedStudentLocation
        case createSessionId
        case logoutFromSession
        case updateStudentLocation
        case getStudentInformation
        
        var stringValue: String {
            switch self {
            
                case .getOrPostStudentLocation:
                    return Endpoints.base + "StudentLocation"
            
                case .getCurrentUserPostedStudentLocation:
                    return Endpoints.base + "StudentLocation?uniqueKey=" + Auth.uniqueKey
                
                case .createSessionId:
                    return Endpoints.base + "session"
                
                case .logoutFromSession:
                    return Endpoints.base + "session"
                    
                case .updateStudentLocation:
                    return Endpoints.base + "StudentLocation/" + Auth.objectId
                    
                case .getStudentInformation:
                    return Endpoints.base + "users/" + Auth.uniqueKey
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getRecentStudentLocations(completion: @escaping ([StudentInformation], Error?) -> Void) {
        let urlBase = URL(string: Endpoints.getOrPostStudentLocation.stringValue)!
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
    
    // MARK: Returns the last posted student location by the current user. If no location posted, returns nil
    
    class func getCurrentUserPostedStudentLocation(completion: @escaping (StudentInformation?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getCurrentUserPostedStudentLocation.url, response: StudentsInformation.self) { (response, error) in
            if let response = response {
                completion(response.results.last, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: Returns the entire dictionary of student information as key value pairs
    
    class func getStudentInformation(completion: @escaping ([String:Any], Error?) -> Void) {
        let studentInfoRequest = URLRequest(url: Endpoints.getStudentInformation.url)
        let session = URLSession.shared
        let task = session.dataTask(with: studentInfoRequest) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([:], error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            do {
                let studentInformationDictionary = try JSONSerialization.jsonObject(with: newData, options: [])
                DispatchQueue.main.async {
                    completion(studentInformationDictionary as! [String : Any], nil)
                }
            } catch let jsonErr {
                DispatchQueue.main.async {
                    completion([:], jsonErr)
                }
            }
        }
        task.resume()
    }
    
    // MARK: Add new student location information
    
    class func postNewStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        
        let studentInformation = StudentInformation(firstName: firstName, lastName: lastName, longitude: longitude, latitude: latitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: Auth.uniqueKey)
        
        var request = URLRequest(url: Endpoints.getOrPostStudentLocation.url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(studentInformation)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(PostStudentLocationResponse.self, from: data)
                Auth.objectId = responseObject.objectId
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    // MARK: Update and existing student location information

    class func updateStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        let studentInformation = StudentInformation(firstName: firstName, lastName: lastName, longitude: longitude, latitude: latitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: Auth.uniqueKey)
        var request = URLRequest(url: Endpoints.updateStudentLocation.url)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(studentInformation)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                     completion(false, error)
                 }
                return
            } else {
                DispatchQueue.main.async {
                    completion(true, error)
                }
            }
        }
        task.resume()
    }
    
    // MARK: Login and create a session id
    
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
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    // MARK: Delete the session id
    
    class func logoutFromSession(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logoutFromSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            // clean up the uniqueKey & session id
            Auth.sessionId = ""
            Auth.uniqueKey = ""
            completion()
        }
        task.resume()
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
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
    }
}
