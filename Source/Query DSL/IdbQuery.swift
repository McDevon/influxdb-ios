import Foundation

public class IdbQuery {
    
    private var _select = ""
    private var _from = [String]()
    private var _whereTests = [String]()
    private var _groupBy = ""
    private var _columnNames = [String]()
    
    internal func setup(select: IdbQuerySelectMaker,
                        from: [String],
                        wheres: [IdbQueryWhereTest],
                        groupBy: IdbQueryGroupByMaker) {
        _select = select.queryString
        _columnNames = select.columnNames
        _from = from
        _whereTests = wheres.map{ $0.queryCompatibleString() }
        _groupBy = groupBy.queryString
    }
    
    public var queryString: String {
        var whereClause = ""
        var intoClause = ""
        let groupByClause = _groupBy.count > 0 ? _groupBy : ""
        var orderByClause = ""
        var limitClause = ""
        var offsetClause = ""
        var slimitClause = ""
        var soffsetClause = ""
        let fromString = _from.map{ "\"\($0)\"" }.joined(separator: ",")
        if _whereTests.count > 0 {
            let whereTestString = _whereTests.joined(separator: " and ")
            whereClause = " where \(whereTestString)"
        }
        
        let queryString = "select \(_select)\(intoClause) from \(fromString)\(whereClause)\(groupByClause)\(orderByClause)\(limitClause)\(offsetClause)\(slimitClause)\(soffsetClause)"
        print("Q: \(queryString)")
        return queryString
    }
    
    public var columnNames: [String] {
        return _columnNames
    }
}

extension InfluxDb {
    
    public static func makeQuery(closure: ((IdbQueryMaker) -> ())) -> IdbQuery {
        let maker = IdbQueryMaker()
        closure(maker)
        return maker.build()
    }
}
