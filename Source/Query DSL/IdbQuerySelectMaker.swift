import Foundation

public class IdbQuerySelectMaker {
    
    public static let defaultFieldName = "value"
    
    private let _maker: IdbQueryMaker
    internal var queryString: String = ""
    internal var columnNames = [String]()
    internal var fieldNames = [String]()
    
    init(_ maker: IdbQueryMaker) {
        _maker = maker
    }
    
    public func all() -> IdbQueryMaker {
        queryString = "*"
        return _maker
    }
    
    public func mean(fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("mean")
        queryString = "mean(\(field))"
        return _maker
    }
    
    public func first(fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("first")
        queryString = "first(\(field))"
        return _maker
    }
    
    public func first(regex: String) -> IdbQueryMaker {
        columnNames.append("first")
        queryString = "first(/\(regex)/)"
        return _maker
    }
    
    public func last(fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("last")
        queryString = "last(\(field))"
        return _maker
    }
    
    public func last(regex: String) -> IdbQueryMaker {
        columnNames.append("last")
        queryString = "last(/\(regex)/)"
        return _maker
    }
    
    public func min(fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("min")
        queryString = "min(\(field))"
        return _maker
    }
    
    public func min(regex: String) -> IdbQueryMaker {
        columnNames.append("min")
        queryString = "min(/\(regex)/)"
        return _maker
    }
    
    public func max(fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("max")
        queryString = "max(\(field))"
        return _maker
    }
    
    public func max(regex: String) -> IdbQueryMaker {
        columnNames.append("max")
        queryString = "max(/\(regex)/)"
        return _maker
    }
    
    public func percentile(_ n: Int, fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("percentile")
        queryString = "percentile(\(field), \(n))"
        return _maker
    }
    
    public func percentile(_ n: Int, regex: String) -> IdbQueryMaker {
        columnNames.append("percentile")
        queryString = "percentile(/\(regex)/, \(n))"
        return _maker
    }
    
    public func sample(_ n: Int, fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("sample")
        queryString = "sample(\(field), \(n))"
        return _maker
    }
    
    public func sample(_ n: Int, regex: String) -> IdbQueryMaker {
        columnNames.append("sample")
        queryString = "sample(/\(regex)/, \(n))"
        return _maker
    }
    
    public func top(_ count: Int, fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("top")
        queryString = "top(\(field), \(count))"
        return _maker
    }
    
    public func bottom(_ count: Int, fromField field: String = defaultFieldName) -> IdbQueryMaker {
        columnNames.append("bottom")
        queryString = "bottom(\(field), \(count))"
        return _maker
    }
}

