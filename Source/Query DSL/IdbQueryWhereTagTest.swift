import Foundation

public class IdbQueryWhereTagTest: IdbQueryWhereTest {
    
    private let maker: IdbQueryMaker
    
    internal let tag: String
    internal var compareTo: String = ""
    internal var comparisonOperator: String = ""
    
    init(maker: IdbQueryMaker, tag: String) {
        self.maker = maker
        self.tag = tag
    }
    
    @discardableResult
    public func equals(_ compareString: String) -> IdbQueryMaker {
        compareTo = compareString
        comparisonOperator = "="
        maker.addWhere(self)
        return maker
    }
    
    func queryCompatibleString() -> String {
        return "\"\(tag)\"\(comparisonOperator)'\(compareTo)'"
    }
}

