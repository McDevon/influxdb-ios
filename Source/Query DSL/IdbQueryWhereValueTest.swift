import Foundation

public class IdbQueryWhereValueTest: IdbQueryWhereTest {
    
    private let maker: IdbQueryMaker
    
    internal var comparisonString = ""
    
    init(maker: IdbQueryMaker) {
        self.maker = maker
    }
    
    @discardableResult
    public func equals(_ compareValue: Double) -> IdbQueryMaker {
        return compare(withOperator: "=", toValue: compareValue)
    }
    
    @discardableResult
    public func lessThan(_ compareValue: Double) -> IdbQueryMaker {
        return compare(withOperator: "<", toValue: compareValue)
    }
    
    @discardableResult
    public func lessThanOrEqual(_ compareValue: Double) -> IdbQueryMaker {
        return compare(withOperator: "<=", toValue: compareValue)
    }
    
    @discardableResult
    public func greaterThan(_ compareValue: Double) -> IdbQueryMaker {
        return compare(withOperator: ">", toValue: compareValue)
    }
    
    @discardableResult
    public func greaterThanOrEqual(_ compareValue: Double) -> IdbQueryMaker {
        return compare(withOperator: ">=", toValue: compareValue)
    }
    
    @discardableResult
    public func between(start: Double, end: Double) -> IdbQueryMaker {
        return compare(withOperators: (">", "<"), andValues: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingStart(start: Double, end: Double) -> IdbQueryMaker {
        return compare(withOperators: (">=", "<"), andValues: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingEnd(start: Double, end: Double) -> IdbQueryMaker {
        return compare(withOperators: (">", "<="), andValues: (start, end))
    }
    
    @discardableResult
    public func betweenIncludingBoth(start: Double, end: Double) -> IdbQueryMaker {
        return compare(withOperators: (">=", "<="), andValues: (start, end))
    }
    
    private func compare(withOperator operatorString: String, toValue compareValue: Double) -> IdbQueryMaker {
        comparisonString = "value \(operatorString) \(compareValue)"
        maker.addWhere(self)
        return maker
    }
    
    private func compare(withOperators operators: (String, String), andValues values: (Double, Double)) -> IdbQueryMaker {
        comparisonString = "time \(operators.0) \(values.0) and time \(operators.1) \(values.1)"
        maker.addWhere(self)
        return maker
    }
    
    func queryCompatibleString() -> String {
        return comparisonString
    }
}
