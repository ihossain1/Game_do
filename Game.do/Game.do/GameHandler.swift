//
//  GameHandler.swift
//  Game.do
//
//  Created by user186880 on 5/16/21.
//

import Foundation
import UIKit

struct GameHandler{
    
    // MARK: - Shared Instance
    
    static let shared = GameHandler()
    
    // MARK: - API Calls
    func searchByGameName(_ gameName: String,
                          completion: @escaping(_ Games: [Game]) -> Void) {
        let parameters = "search " + #""\#(gameName)""# + "; fields name, id, cover, alternative_names, genres, game_modes, platforms, summary, url;"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://api.igdb.com/v4/games")!, timeoutInterval: Double.infinity)
        request.addValue("wyddew28i6etbmp8ftslif5iau2rge", forHTTPHeaderField: "Client-ID")
        request.addValue("Bearer 2ym8ed59v24q234pcnyei4xcj4dvx7", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")


        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                print(String(describing: error))
                return
            } else {
                guard let receivedData = data else {
                    completion([])
                    return
                }
                let jsonDecoder = JSONDecoder()
                do {
                    do {
                        let j = try JSONSerialization.jsonObject(with: receivedData, options: .mutableContainers)
                        print(j)
                       } catch let myJSONError {
                           print(myJSONError)
                       }
                    print(receivedData)
                    let games = try jsonDecoder.decode([Game].self, from: receivedData)
                    completion(games)
                    return
                } catch {
                    print(error.localizedDescription, error)
                    completion([])
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: - Get Cover Art Data
    
    func getCoverArtworkByGameId(_ gameId: Int,
                                 completion: @escaping(_ artwork: [Artwork]) -> Void) {
        let parameters = "fields *; exclude image_id; where game = \(gameId);"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "https://api.igdb.com/v4/covers")!, timeoutInterval: Double.infinity)
        request.addValue("wyddew28i6etbmp8ftslif5iau2rge", forHTTPHeaderField: "Client-ID")
        request.addValue("Bearer 2ym8ed59v24q234pcnyei4xcj4dvx7", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                print(String(describing: error))
                return
            } else {
                guard let receivedData = data else {
                    completion([])
                    return
                }
                let jsonDecoder = JSONDecoder()
                do {
                    do{
                    let json = try JSONSerialization.jsonObject(with: receivedData, options: []) as? [String : Any]
                        print(json)
                    }catch{ print("erroMsg") }
                    
                    let artworks = try jsonDecoder.decode([Artwork].self, from: receivedData)
                   
//                    var artArray = [Artwork]()
//                    artArray.append(artworks)
                    completion(artworks)
                    return
                } catch {
                    print("Error Decoding into Artwork", error.localizedDescription, error)
                    completion([])
                }
            }
        }
        task.resume()
    }
    
    func getCoverImageByGameId(_ imageId: Int,
                               completion: @escaping(_ coverArt: UIImage?) -> Void) {
        getCoverArtworkByGameId(imageId) { (artworks) in
            guard let imageUrlString = artworks[0].url else { return }
            guard let imageUrl = URL(string:"https:" + imageUrlString) else { return }
            
            var request = URLRequest(url: imageUrl)
            
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                if error != nil {
                    print(error?.localizedDescription, error)
                    completion(nil)
                } else {
                    guard let receivedData = data else {
                        completion(nil)
                        return
                    }
                    completion(UIImage(data: receivedData as Data))
                }
            }
            task.resume()
        }
    }
    
    func getCoverImageByArtworks(_ artworks: [Artwork],
                                  completion: @escaping(_ coverArt: UIImage?) -> Void) {
        if artworks.count < 1 {
            completion(nil)
            return
        } else {
            guard let imageUrlString = artworks[0].url else { return }
            guard let imageUrl = URL(string:"https:" + imageUrlString) else { return }
            
            var request = URLRequest(url: imageUrl)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error?.localizedDescription as Any, error as Any)
                    completion(nil)
                } else {
                    guard let recievedData = data else {
                        completion(nil)
                        return
                    }
                    completion(UIImage(data: recievedData as Data))
                }
            }
            task.resume()
        }
    }
    
    func getGenreByGenreId(_ genreId: Int,
                           completion: @escaping(_ genres: [Genre]) -> Void) {
        let parameters = "fields name; where id = \(genreId);"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "https://api.igdb.com/v4/genres")!, timeoutInterval: Double.infinity)
        request.addValue("wyddew28i6etbmp8ftslif5iau2rge", forHTTPHeaderField: "Client-ID")
        request.addValue("Bearer 2ym8ed59v24q234pcnyei4xcj4dvx7", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        request.httpBody = postData

        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error, error?.localizedDescription)
                completion([])
                return
            } else {
                guard let recievedData = data else {
                    completion([])
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let genres = try decoder.decode([Genre].self, from: recievedData)
                    completion(genres)
                    return
                } catch {
                    print("Error parsing data into genre object", error, error.localizedDescription)
                    completion([])
                    return
                }
            }
        }
        task.resume()
    }
    
    func getGenresByGenreIds(_ genreIds: [Int],
                          completion: @escaping(_ genres: [Genre]) -> Void) {
        var idArrayString = "("
        var index = 0
        for id in genreIds {
           if index < genreIds.count - 1 {
               idArrayString.append("\(id),")
           } else {
               idArrayString.append("\(id))")
           }
           index += 1
        }
        let parameters = "fields name; where id = \(idArrayString);"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://api.igdb.com/v4/genres")!, timeoutInterval: Double.infinity)
        request.addValue("wyddew28i6etbmp8ftslif5iau2rge", forHTTPHeaderField: "Client-ID")
        request.addValue("Bearer 2ym8ed59v24q234pcnyei4xcj4dvx7", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        request.httpBody = postData

        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error, error?.localizedDescription)
                completion([])
                return
            } else {
                guard let recievedData = data else {
                    completion([])
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let genres = try decoder.decode([Genre].self, from: recievedData)
                    completion(genres)
                    return
                } catch {
                    print("Error parsing data into genre object", error, error.localizedDescription)
                    completion([])
                    return
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Get Platform Data
    
    func getPlatformByPlatformId(_ platformId: Int,
                             completion: @escaping(_ platforms: [Platform]) -> Void) {
        let parameters = "fields id, abbreviation, alternative_name, category, generation, name, platform_logo, url; where id = \(platformId);"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "https://api.igdb.com/v4/platforms")!, timeoutInterval: Double.infinity)
        request.addValue("wyddew28i6etbmp8ftslif5iau2rge", forHTTPHeaderField: "Client-ID")
        request.addValue("Bearer 2ym8ed59v24q234pcnyei4xcj4dvx7", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error, error?.localizedDescription)
                completion([])
                return
            }
            guard let retreivedData = data else { return }
            let decoder = JSONDecoder()
            do {
                let platforms = try decoder.decode([Platform].self, from: retreivedData)
                completion(platforms)
                return
            } catch {
                print("Error Parsing Platform into Object", error, error.localizedDescription)
                completion([])
                return
            }
        }
        task.resume()
    }
    
    func getPlatformsByPlatformIds(_ platformIds: [Int],
                             completion: @escaping(_ platforms: [Platform]) -> Void) {
        var idArrayString = "("
        var index = 0
        for id in platformIds {
           if index < platformIds.count - 1 {
               idArrayString.append("\(id),")
           } else {
               idArrayString.append("\(id))")
           }
           index += 1
        }
        let parameters = "fields id, abbreviation, alternative_name, category, generation, name, platform_logo, url; where id = \(idArrayString);"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "https://api.igdb.com/v4/platforms")!, timeoutInterval: Double.infinity)
        request.addValue("wyddew28i6etbmp8ftslif5iau2rge", forHTTPHeaderField: "Client-ID")
        request.addValue("Bearer 2ym8ed59v24q234pcnyei4xcj4dvx7", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error, error?.localizedDescription)
                completion([])
                return
            }
            guard let retreivedData = data else { return }
            let decoder = JSONDecoder()
            do {
                let platforms = try decoder.decode([Platform].self, from: retreivedData)
                completion(platforms)
                return
            } catch {
                print("Error Parsing Platform into Object", error, error.localizedDescription)
                completion([])
                return
            }
        }
        task.resume()
    }
    
    
    // MARK: - Get Game Mode Data
    
    func getGameModesByModeId(_ gameModeId: Int,
                              completion: @escaping(_ gameModes: [GameMode]) -> Void) {
        let parameters = "fields name; where id = \(gameModeId);"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "https://api.igdb.com/v4/game_modes")!, timeoutInterval: Double.infinity)
        request.addValue("wyddew28i6etbmp8ftslif5iau2rge", forHTTPHeaderField: "Client-ID")
        request.addValue("Bearer 2ym8ed59v24q234pcnyei4xcj4dvx7", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error,error?.localizedDescription)
                completion([])
                return
            } else {
                guard let recievedData = data else {
                    completion([])
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let gameModes = try decoder.decode([GameMode].self, from: recievedData)
                    completion(gameModes)
                    return
                } catch {
                    print("error parsing data into gameMode object", error, error.localizedDescription)
                    completion([])
                    return
                }
            }
        }
        task.resume()
    }
    
    func getGameModesByModeIds(_ gameModeIds: [Int],
                               completion: @escaping(_ gameModes: [GameMode]) -> Void) {
        var idArrayString = "("
        var index = 0
        for id in gameModeIds {
            if index < gameModeIds.count - 1 {
                idArrayString.append("\(id),")
            } else {
                idArrayString.append("\(id))")
            }
            index += 1
        }
        let parameters = "fields name; where id = \(idArrayString);"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://api.igdb.com/v4/game_modes")!, timeoutInterval: Double.infinity)
        request.addValue("wyddew28i6etbmp8ftslif5iau2rge", forHTTPHeaderField: "Client-ID")
        request.addValue("Bearer 2ym8ed59v24q234pcnyei4xcj4dvx7", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if error != nil {
                print(error,error?.localizedDescription)
                completion([])
                return
            } else {
                guard let recievedData = data else {
                    completion([])
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let gameModes = try decoder.decode([GameMode].self, from: recievedData)
                    completion(gameModes)
                    return
                } catch {
                    print("error parsing data into gameMode object", error, error.localizedDescription)
                    completion([])
                    return
                }
            }
        }
        task.resume()
    }
    
}
