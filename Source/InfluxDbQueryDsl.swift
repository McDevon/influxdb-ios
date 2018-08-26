import Foundation

class InfluxDbQuery {
    
    private var _select = ""
    private var _from = [String]()
    private var _whereTests = [String]()
    private var _columnNames = [String]()
    
    internal func setup(select: InfluxDbQuerySelectMaker, from: [String], wheres: [InfluxDbQueryWhereTest]) {
        _select = select.queryString
        _columnNames = select.columnNames
        _from = from
        _whereTests = wheres.map{ $0.queryCompatibleString() }
    }
    
    public var queryString: String {
        var whereClause = ""
        var intoClause = ""
        var groupByClause = ""
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
        return "select \(_select)\(intoClause) from \(fromString)\(whereClause)\(groupByClause)\(orderByClause)\(limitClause)\(offsetClause)\(slimitClause)\(soffsetClause)"
    }
    
    public var columnNames: [String] {
        return _columnNames
    }
}

class InfluxDbQueryMaker {
    
    private let _query = InfluxDbQuery()
    private lazy var _select = InfluxDbQuerySelectMaker(self)
    private lazy var _where = InfluxDbQueryWhereMaker(self)
    private var _from = [String]()

    private var whereObjects = [InfluxDbQueryWhereTest]()
    
    public var select: InfluxDbQuerySelectMaker {
        return _select
    }
    
    @discardableResult
    public func from(_ from: String...) -> InfluxDbQueryMaker {
        _from = from
        return self
    }
    
    public var `where`: InfluxDbQueryWhereMaker {
        return _where
    }
    
    internal func addWhere(_ whereObject: InfluxDbQueryWhereTest) {
        whereObjects.append(whereObject)
    }
    
    internal func build() -> InfluxDbQuery {
        _query.setup(select: _select, from: _from, wheres: whereObjects)
        return _query
    }
}

class InfluxDbQuerySelectMaker {
    
    private static let defaultFieldName = "value"
    
    private let maker: InfluxDbQueryMaker
    internal var queryString: String = ""
    internal var columnNames = [String]()
    internal var fieldNames = [String]()
    
    init(_ maker: InfluxDbQueryMaker) {
        self.maker = maker
    }
    
    public func last(fromField field: String = defaultFieldName) -> InfluxDbQueryMaker {
        columnNames.append("last")
        queryString = "last(\(field))"
        return maker
    }
    
    public func min(fromField field: String = defaultFieldName) -> InfluxDbQueryMaker {
        columnNames.append("min")
        queryString = "min(\(field))"
        return maker
    }
    
    public func bottom(_ count: Int, fromField field: String = defaultFieldName) -> InfluxDbQueryMaker {
        columnNames.append("bottom")
        queryString = "bottom(\(field), \(count))"
        return maker
    }
}

class InfluxDbQueryWhereMaker {
    
    private let maker: InfluxDbQueryMaker

    init(_ maker: InfluxDbQueryMaker) {
        self.maker = maker
    }
    
    public func tag(_ tag: String) -> InfluxDbQueryWhereTagTest {
        return InfluxDbQueryWhereTagTest(maker: maker, tag: tag)
    }
    
    public var time: InfluxDbQueryWhereTimeTest {
        return InfluxDbQueryWhereTimeTest(maker: maker)
    }
    
    public var value: InfluxDbQueryWhereValueTest {
        return InfluxDbQueryWhereValueTest(maker: maker)
    }
}

protocol InfluxDbQueryWhereTest {
    func queryCompatibleString() -> String
}

class InfluxDbQueryWhereTagTest: InfluxDbQueryWhereTest {
    
    private let maker: InfluxDbQueryMaker
    
    internal let tag: String
    internal var compareTo: String = ""
    internal var comparisonOperator: String = ""
    
    init(maker: InfluxDbQueryMaker, tag: String) {
        self.maker = maker
        self.tag = tag
    }
    
    @discardableResult
    public func equals(_ compareString: String) -> InfluxDbQueryMaker {
        compareTo = compareString
        comparisonOperator = "="
        maker.addWhere(self)
        return maker
    }
    
    func queryCompatibleString() -> String {
        return "\"\(tag)\"\(comparisonOperator)'\(compareTo)'"
    }
}

class InfluxDbQueryWhereTimeTest: InfluxDbQueryWhereTest {
    
    private let maker: InfluxDbQueryMaker
    
    internal var comparisonString = ""
    
    init(maker: InfluxDbQueryMaker) {
        self.maker = maker
    }
    
    @discardableResult
    public func equals(_ compareDate: Date) -> InfluxDbQueryMaker {
        return compare(withOperator: "=", toDate: compareDate)
    }
    
    @discardableResult
    public func lessThan(_ compareDate: Date) -> InfluxDbQueryMaker {
        return compare(withOperator: "<", toDate: compareDate)
    }
    
    @discardableResult
    public func lessThanOrEqual(_ compareDate: Date) -> InfluxDbQueryMaker {
        return compare(withOperator: "<=", toDate: compareDate)
    }
    
    @discardableResult
    public func greaterThan(_ compareDate: Date) -> InfluxDbQueryMaker {
        return compare(withOperator: ">", toDate: compareDate)
    }
    
    @discardableResult
    public func greaterThanOrEqual(_ compareDate: Date) -> InfluxDbQueryMaker {
        return compare(withOperator: ">=", toDate: compareDate)
    }
    
    @discardableResult
    public func between(start: Date, end: Date) -> InfluxDbQueryMaker {
        return compare(withOperators: (">", "<"), andDates: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingStart(start: Date, end: Date) -> InfluxDbQueryMaker {
        return compare(withOperators: (">=", "<"), andDates: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingEnd(start: Date, end: Date) -> InfluxDbQueryMaker {
        return compare(withOperators: (">", "<="), andDates: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingBoth(start: Date, end: Date) -> InfluxDbQueryMaker {
        return compare(withOperators: (">=", "<="), andDates: (start, end))
    }
    
    private func compare(withOperator operatorString: String, toDate compareDate: Date) -> InfluxDbQueryMaker {
        let timeString = Formatter.iso8601.string(from: compareDate)
        comparisonString = "time \(operatorString) '\(timeString)'"
        maker.addWhere(self)
        return maker
    }
    
    private func compare(withOperators operators: (String, String), andDates dates: (Date, Date)) -> InfluxDbQueryMaker {
        let formatter = Formatter.iso8601
        let date1String = formatter.string(from: dates.0)
        let date2String = formatter.string(from: dates.1)
        comparisonString = "time \(operators.0) '\(date1String)' and time \(operators.1) '\(date2String)'"
        maker.addWhere(self)
        return maker
    }
    
    func queryCompatibleString() -> String {
        return comparisonString
    }
}

class InfluxDbQueryWhereValueTest: InfluxDbQueryWhereTest {
    
    private let maker: InfluxDbQueryMaker
    
    internal var comparisonString = ""
    
    init(maker: InfluxDbQueryMaker) {
        self.maker = maker
    }
    
    @discardableResult
    public func equals(_ compareValue: Double) -> InfluxDbQueryMaker {
        return compare(withOperator: "=", toValue: compareValue)
    }
    
    @discardableResult
    public func lessThan(_ compareValue: Double) -> InfluxDbQueryMaker {
        return compare(withOperator: "<", toValue: compareValue)
    }
    
    @discardableResult
    public func lessThanOrEqual(_ compareValue: Double) -> InfluxDbQueryMaker {
        return compare(withOperator: "<=", toValue: compareValue)
    }
    
    @discardableResult
    public func greaterThan(_ compareValue: Double) -> InfluxDbQueryMaker {
        return compare(withOperator: ">", toValue: compareValue)
    }
    
    @discardableResult
    public func greaterThanOrEqual(_ compareValue: Double) -> InfluxDbQueryMaker {
        return compare(withOperator: ">=", toValue: compareValue)
    }
    
    @discardableResult
    public func between(start: Double, end: Double) -> InfluxDbQueryMaker {
        return compare(withOperators: (">", "<"), andValues: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingStart(start: Double, end: Double) -> InfluxDbQueryMaker {
        return compare(withOperators: (">=", "<"), andValues: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingEnd(start: Double, end: Double) -> InfluxDbQueryMaker {
        return compare(withOperators: (">", "<="), andValues: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingBoth(start: Double, end: Double) -> InfluxDbQueryMaker {
        return compare(withOperators: (">=", "<="), andValues: (start, end))
    }
    
    private func compare(withOperator operatorString: String, toValue compareValue: Double) -> InfluxDbQueryMaker {
        comparisonString = "value \(operatorString) \(compareValue)"
        maker.addWhere(self)
        return maker
    }
    
    private func compare(withOperators operators: (String, String), andValues values: (Double, Double)) -> InfluxDbQueryMaker {
        comparisonString = "time \(operators.0) \(values.0) and time \(operators.1) \(values.1)"
        maker.addWhere(self)
        return maker
    }
    
    func queryCompatibleString() -> String {
        return comparisonString
    }
}

extension InfluxDb {
    
    public static func makeQuery(closure: ((InfluxDbQueryMaker) -> ())) -> InfluxDbQuery {
        let maker = InfluxDbQueryMaker()
        closure(maker)
        return maker.build()
    }
}
