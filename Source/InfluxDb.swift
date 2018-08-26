import Foundation

public class InfluxDb {
    
    private static var dbName = "database"
    private static var dbUrl = "localhost:8086"
    
    public static func setup(url: String, database: String) {
        dbUrl = url
        dbName = database
    }
    
    public static func query(_ queries: [InfluxDbQuery], completion: @escaping ([StatementResult]?) -> Void) {
        return InfluxDb.query(queries.map { $0.queryString }.joined(separator: ";")) { responseJson in
            guard let responseJson = responseJson,
                let resultArray = responseJson["results"] as? [[String: Any]] else {
                    completion(nil)
                    return
            }
            
            var results = [StatementResult]()
            
            for resultDict in resultArray {
                guard let seriesArray = resultDict["series"] as? [[String: Any]],
                    let id = resultDict["statement_id"] as? Int else {
                        continue
                }
                let series = parseSeries(seriesArray)
                results.append(StatementResult(id: id, results: series, query: queries[id]))
            }
            
            results.sort { $0.statementId < $1.statementId }
            
            completion(results)
        }
    }
    
    public static func query(_ query: InfluxDbQuery, completion: @escaping ([StatementResult]?) -> Void) {
        return InfluxDb.query([query], completion: completion)
    }
    
    static private func query(_ queryString: String, completion: @escaping ([String: Any]?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            
            let bodyObject: [String: String] = [
                "db": dbName,
                "q": queryString
            ]
            
            let userRequestOpt = URLRequest.urlEncodedApiRequest(endpoint: URL.init(string:
                "\(dbUrl)/query?pretty=true")!, method: "POST", body: bodyObject)
            
            guard let userRequest = userRequestOpt else {
                completion(nil)
                return
            }
            
            let task = URLSession.shared.dataTask(with: userRequest) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                completion(responseJSON as? [String: Any])
            }
            
            task.resume()
        }
    }
    
    private static func parseSeries(_ series: [[String: Any]]) -> [DataSeries] {
        var result = [DataSeries]()
        
        for dict in series {
            guard let name = dict["name"] as? String,
                let columns = dict["columns"] as? [String],
                let valueLists = dict["values"] as? [[Any]] else { continue }
            
            var columnNames = [String]()
            var columnDicts = [String: [Any]]()
            
            for i in 0 ..< columns.count {
                let colName = columns[i]
                columnDicts[colName] = [Any]()
                columnNames.append(colName)
            }
            
            for values in valueLists {
                for i in 0 ..< values.count {
                    columnDicts[columnNames[i]]?.append(values[i])
                }
            }
            
            result.append(DataSeries(name: name, values: columnDicts))
        }
        
        return result
    }
}
