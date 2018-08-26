import Foundation

extension URLRequest {
    static func urlEncodedApiRequest(endpoint: URL, method: String, body: [String: String]) -> URLRequest? {
        func percentEscapeString(_ string: String) -> String {
            var characterSet = NSCharacterSet.alphanumerics
            characterSet.insert(charactersIn: "-._* ")
            
            return string.addingPercentEncoding(withAllowedCharacters: characterSet)!.replacingOccurrences(of: " ", with: "+")
        }
        
        let parameterArray = body.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(percentEscapeString(value))"
        }
        
        let stringParams = parameterArray.joined(separator: "&")
        let bodyData = stringParams.data(using: String.Encoding.utf8)
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = method
        
        request.httpBody = bodyData
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    static func jsonApiRequest(endpoint: URL, body: [String: Any]) -> URLRequest? {
        let serializedJson = try? JSONSerialization.data(withJSONObject: body)
        
        guard let json = serializedJson else { return nil }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = json
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
