//
//  AlbumController.swift
//  Albums
//
//  Created by Akmal Nurmatov on 5/7/20.
//  Copyright © 2020 Akmal Nurmatov. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
}

class AlbumController {
    
        var albums: [Album] = []
        var baseURL = URL(string: "https://albums-c6863.firebaseio.com/")!
         
        func getAlbums(completion: @escaping (Error?) -> Void) {
            let requestURL = baseURL.appendingPathExtension("json")
        
            let request = URLRequest(url: requestURL)
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                    completion(error)
                    return
                }
                guard let data = data else {
                    print("no data recieved")
                    completion(error)
                    return
                }
                do {
                    let jsonDecoder = JSONDecoder()
                    let decodedAlbums = try jsonDecoder.decode([String:Album].self, from: data)
                    decodedAlbums.values.forEach { (album) in
                        self.albums.append(album)
                    }
                } catch {
                    print(error)
                    completion(.some(error))
                }
         }.resume()
        }
    
        func putAlbum(_ album:Album, completion: @escaping (Error?) -> Void) {
            let requestURL = baseURL.appendingPathComponent(album.id).appendingPathExtension("json")
                var request = URLRequest(url: requestURL)
                request.httpMethod = HTTPMethod.put.rawValue

                do {
                    let albumData = try JSONEncoder().encode(album)
                    request.httpBody = albumData
                } catch {
                    NSLog("Error encoding album: \(error)")
                    completion(error)
                    return
                }
        }
    
    
        
        func testDecodingExampleAlbum() {
            guard let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else {
                print("could not locate JSON file in App bundle.")
                return
            }
            do {
                let jsonData = try Data(contentsOf: urlPath)
                let jsonDecoder = JSONDecoder()
                let data = try jsonDecoder.decode(Album.self, from: jsonData)
                print(data)
            } catch {
                print("error decoding data from JSON file: \(error)")
                return
            }
        }
    
        func testEncodingExampleAlbum() {
            guard let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else {
                    print("could not locate JSON file in App bundle.")
                    return
                }
                do {
                    let jsonData = try Data(contentsOf: urlPath)
                    let jsonDecoder = JSONDecoder()
                    let data = try jsonDecoder.decode(Album.self, from: jsonData)
                    let jsonEncoder = JSONEncoder()
                    jsonEncoder.outputFormatting = .prettyPrinted
                    let newData = try jsonEncoder.encode(data)
                    let stringData = String(data: newData, encoding: .utf8)
                    print(stringData!)
                } catch {
                    print("error encoding data from JSON file: \(error)")
                    return
            }
        }

}
