import Foundation

public class DataSeries {
    let name: String
    let values: [String: [Any]]
    
    init(name: String, values: [String: [Any]]) {
        self.name = name
        self.values = values
    }
}

public class StatementResult {
    let statementId: Int
    let resultSeries: [DataSeries]
    let query: IdbQuery
    
    init(id: Int, results: [DataSeries], query: IdbQuery) {
        statementId = id
        resultSeries = results
        self.query = query
    }
    
    public func intResults(forSeries seriesName: String) -> [Int]? {
        return resultSeries.filter { $0.name == seriesName }.first?.values[query.columnNames.first ?? ""] as? [Int]
    }
    
    public func doubleResults(forSeries seriesName: String) -> [Double]? {
        return resultSeries.filter { $0.name == seriesName }.first?.values[query.columnNames.first ?? ""] as? [Double]
    }
    
    public func stringResults(forSeries seriesName: String) -> [String]? {
        return resultSeries.filter { $0.name == seriesName }.first?.values[query.columnNames.first ?? ""] as? [String]
    }
    
    public func dateResults(forSeries seriesName: String) -> [Date]? {
        let strings = resultSeries.filter({ $0.name == seriesName }).first?.values["time"] as? [String]
        return strings?.compactMap { Formatter.iso8601.date(from: $0) ?? nil }
    }
}
