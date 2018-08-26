import Foundation

public class IdbQuerySelectMaker {
    
    public static let defaultFieldName = "value"
    
    private let maker: IdbQueryMaker
    internal var queryString: String = ""
    internal var columnNames = [String]()
    internal var fieldNames = [String]()
    
    init(_ maker: IdbQueryMaker) {
        self.maker = maker
    }
    
    public func last(fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("last")
        queryString = "last(\(field))"
        return maker
    }
    
    public func min(fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("min")
        queryString = "min(\(field))"
        return maker
    }
    
    public func bottom(_ count: Int, fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("bottom")
        queryString = "bottom(\(field), \(count))"
        return maker
    }
}

