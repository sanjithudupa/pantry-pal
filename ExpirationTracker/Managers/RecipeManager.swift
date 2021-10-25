//
//  RecipeManager.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/14/21.
//

import Foundation

class RecipeManager {
    
    private final var url = "https://d1.supercook.com/dyn/"
    private final var search = "results"
    private final var details = "details"
    
    func searchForRecipes(ingredients: [String],completion:@escaping(_ recipes: [Recipe]) -> ()) {
        let url = URL(string: url + search)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "needsimage": 1,
            "app": 1,
            "kitchen": ingredients.joined(separator: ","),
            "focus": "",
            "kw": "",
            "catname": "",
            "start": 0,
            "fave": false,
            "lh": "dd79421ce8abb01f5c859717ba6ffb3caecdae9c",
            "lang": "en"
        ]
        
        request.httpBody = parameters.percentEncoded()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            let dataString = String(decoding: data, as: UTF8.self)
            let json = RecipeManager.getInstance().convertStringToDictionary(text: dataString)
            
            if(json != nil) {
//                print(type(of: json!["results"]!))
                let results = json!["results"]! as! [Any?]
                let count = json!["results"]!.count!
                
                var recipes = [Recipe]()
                
                for i in 0...(count-1) {
                    let recipe = (results[i]!) as! NSDictionary
                    let id = recipe["id"] as! String
                    
                    RecipeManager.getInstance().getRecipeDetails(id: id, completion: { (r) in
                            var recipeObj = r!;
                            recipeObj.domain = recipe["domain"] as! String
                            recipeObj.title = recipe["title"]! as! String
                            
                            recipes.append(recipeObj)
                        
                            if (i == count-1) {
                                completion(recipes)
                            }
                        })
                }

                
//                for list in Array(arrayLiteral: json!["results"]!) {
//                    for result in Array(arrayLiteral: list) {
//                        print(result)
//                    }
//                }
            }
        }.resume()
    }
    
    func getRecipeDetails(id: String, completion:@escaping(_ recipe:Recipe?) -> () ) {
        
        let url = URL(string: url + details)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "rid": id,
            "lang": "en"
//            "ingredients": "garlic,onion,tomato"
        ]
        
        request.httpBody = parameters.percentEncoded()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            let dataString = String(decoding: data, as: UTF8.self)
            let json = RecipeManager.getInstance().convertStringToDictionary(text: dataString)
            
            if(json != nil) {
                let recipeInfo = json!["recipe"] as! NSDictionary
//                let recipeAtrs = json!["recipe"] as! NSDictionary
                let recipe = Recipe(title: "", domain: "", url: recipeInfo["hash"] as! String, imageAddress: recipeInfo["img"] as! String, ingredients:( recipeInfo["needs"] as? [String]) ?? [String](), tags: json!["tags"] as! [String])
                
                completion(recipe)
            }
        }.resume()
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
    
    private static var instance: RecipeManager? = nil
    
    public static func getInstance() -> RecipeManager {
        if (instance == nil) {
            instance = RecipeManager()
        }
        return instance!
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
