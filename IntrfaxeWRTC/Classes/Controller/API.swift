//
//  API.swift
//  IntrfaxeWRTC
//
//  Created by Muhammad Mehdi on 22/11/2021.
//

import Foundation



public class IntrfaxeWRTC{
    
    
    public static let sharedInstance = IntrfaxeWRTC()

    
    private var _accessKey : String = ""
   public var accessKey : String{
        
        get {
            return _accessKey
        }
        set(newVal){
            if newVal.isEmpty{
//                assertionFailure("Access Key must not be empty!")
            }else{
                _accessKey = newVal
            }
        }
        
    }
    
    private  var _apiURL : String = ""
    public var apiURL : String{
        
        get {
            return _apiURL
        }
        set(newVal){
            if newVal.isEmpty{
                assertionFailure("URL must not be empty!")
            }else{
                _apiURL = newVal
            }
        }
        
    }
    
    
    
    func createRoom(roomName:String, completionHandler: @escaping (CreateRoom?, CreateRoomFailure?) -> Void) {
        let url = URL(string: _apiURL )!
        let parameterDictionary = ["RoomName" : roomName]
        print("parameterDictionary: \(parameterDictionary)")
        print("_accessKey: \(_accessKey)")

        var request = URLRequest(url: url)
           request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(_accessKey, forHTTPHeaderField: "AccessKey")
           guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
               return
           }
           request.httpBody = httpBody
        
        

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with creating room: \(error)")
              completionHandler(nil,CreateRoomFailure(response: Response(responseCode: 1, responseMessage: error.localizedDescription)))

            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            print("Error with the response, unexpected status code: \(response)")
                    completionHandler(nil,CreateRoomFailure(response: Response(responseCode: 1, responseMessage: response?.description ?? "Error")))

            return
          }
//            print("data: \(data)")

//            if let data = data {
//                   do {
//                       let json = try JSONSerialization.jsonObject(with: data, options: [])
//                       print(json)
//                   } catch {
//                       print(error)
//                   }
//               }
            //
            
            if let data = data {
                if let createRoom = try? JSONDecoder().decode(CreateRoom.self, from: data) {
                    completionHandler(createRoom,nil)
                } else if let createRoom = try? JSONDecoder().decode(CreateRoomFailure.self, from: data) {
                    completionHandler(nil,createRoom)
                }
            }
        })
        task.resume()
    }
    
    
    
    
}


//for create room model

// MARK: - Welcome
struct CreateRoom: Codable {
    var response: Response
    var result: Result
}

struct CreateRoomFailure: Codable {
    var response: Response
//    var result: Result
}


// MARK: - Response
struct Response: Codable {
    let responseCode: Int
    let responseMessage: String
}

// MARK: - Result
struct Result: Codable {
    let roomSID, roomName, status: String
    let sender: Int
    let transaction: String
    let sessionID: Int

    enum CodingKeys: String, CodingKey {
        case roomSID = "RoomSID"
        case roomName = "RoomName"
        case status = "Status"
        case sender = "Sender"
        case transaction = "Transaction"
        case sessionID = "SessionId"
    }
}
