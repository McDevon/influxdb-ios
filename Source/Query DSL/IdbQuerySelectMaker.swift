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
    
    public func all() -> IdbQueryMaker {
        queryString = "*"
        return maker
    }
    
    public func first(fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("first")
        queryString = "first(\(field))"
        return maker
    }
    
    public func first(regex: String) -> IdbQueryMaker {
        columnNames.append("first")
        queryString = "first(/\(regex)/)"
        return maker
    }
    
    public func last(fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("last")
        queryString = "last(\(field))"
        return maker
    }
    
    public func last(regex: String) -> IdbQueryMaker {
        columnNames.append("last")
        queryString = "last(/\(regex)/)"
        return maker
    }
    
    public func min(fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("min")
        queryString = "min(\(field))"
        return maker
    }
    
    public func min(regex: String) -> IdbQueryMaker {
        columnNames.append("min")
        queryString = "min(/\(regex)/)"
        return maker
    }
    
    public func max(fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("max")
        queryString = "max(\(field))"
        return maker
    }
    
    public func max(regex: String) -> IdbQueryMaker {
        columnNames.append("max")
        queryString = "max(/\(regex)/)"
        return maker
    }
    
    public func percentile(_ n: Int, fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("percentile")
        queryString = "percentile(\(field), \(n))"
        return maker
    }
    
    public func percentile(_ n: Int, regex: String) -> IdbQueryMaker {
        columnNames.append("percentile")
        queryString = "percentile(/\(regex)/, \(n))"
        return maker
    }
    
    public func sample(_ n: Int, fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("sample")
        queryString = "sample(\(field), \(n))"
        return maker
    }
    
    public func sample(_ n: Int, regex: String) -> IdbQueryMaker {
        columnNames.append("sample")
        queryString = "sample(/\(regex)/, \(n))"
        return maker
    }
    
    public func top(_ count: Int, fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("top")
        queryString = "top(\(field), \(count))"
        return maker
    }
    
    public func bottom(_ count: Int, fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("bottom")
        queryString = "bottom(\(field), \(count))"
        return maker
    }
}

