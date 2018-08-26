import Foundation

public class IdbQueryWhereTimeTest: IdbQueryWhereTest {
    
    private let maker: IdbQueryMaker
    
    internal var comparisonString = ""
    
    init(maker: IdbQueryMaker) {
        self.maker = maker
    }
    
    @discardableResult
    public func equals(_ compareDate: Date) -> IdbQueryMaker {
        return compare(withOperator: "=", toDate: compareDate)
    }
    
    @discardableResult
    public func lessThan(_ compareDate: Date) -> IdbQueryMaker {
        return compare(withOperator: "<", toDate: compareDate)
    }
    
    @discardableResult
    public func lessThanOrEqual(_ compareDate: Date) -> IdbQueryMaker {
        return compare(withOperator: "<=", toDate: compareDate)
    }
    
    @discardableResult
    public func greaterThan(_ compareDate: Date) -> IdbQueryMaker {
        return compare(withOperator: ">", toDate: compareDate)
    }
    
    @discardableResult
    public func greaterThanOrEqual(_ compareDate: Date) -> IdbQueryMaker {
        return compare(withOperator: ">=", toDate: compareDate)
    }
    
    @discardableResult
    public func between(start: Date, end: Date) -> IdbQueryMaker {
        return compare(withOperators: (">", "<"), andDates: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingStart(start: Date, end: Date) -> IdbQueryMaker {
        return compare(withOperators: (">=", "<"), andDates: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingEnd(start: Date, end: Date) -> IdbQueryMaker {
        return compare(withOperators: (">", "<="), andDates: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingBoth(start: Date, end: Date) -> IdbQueryMaker {
        return compare(withOperators: (">=", "<="), andDates: (start, end))
    }
    
    private func compare(withOperator operatorString: String, toDate compareDate: Date) -> IdbQueryMaker {
        let timeString = Formatter.iso8601.string(from: compareDate)
        comparisonString = "time \(operatorString) '\(timeString)'"
        maker.addWhere(self)
        return maker
    }
    
    private func compare(withOperators operators: (String, String), andDates dates: (Date, Date)) -> IdbQueryMaker {
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
