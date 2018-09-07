import Foundation

public class IdbQueryGroupByMaker {
    
    private let maker: IdbQueryMaker
    private var queryStrings = [String]()
    private var fill = " fill(previous)"
    
    init(_ maker: IdbQueryMaker) {
        self.maker = maker
    }
    
    internal var queryString: String {
        guard queryStrings.count > 0 else { return "" }
        return " group by \(queryStrings.joined(separator: ","))\(fill)"
    }
    
    public func time(_ time: TimeInterval) -> IdbQueryMaker {
        queryStrings.append("time(\(time.format(f: ".0"))s)")
        return maker
    }
}
