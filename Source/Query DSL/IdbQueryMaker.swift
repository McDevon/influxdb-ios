import Foundation

public class IdbQueryMaker {
    
    private let _query = IdbQuery()
    private lazy var _select = IdbQuerySelectMaker(self)
    private lazy var _where = IdbQueryWhereMaker(self)
    private lazy var _groupBy = IdbQueryGroupByMaker(self)
    private var _from = [String]()
    
    private var _whereObjects = [IdbQueryWhereTest]()
    
    public var select: IdbQuerySelectMaker {
        return _select
    }
    
    @discardableResult
    public func from(_ from: String...) -> IdbQueryMaker {
        _from = from
        return self
    }
    
    public var `where`: IdbQueryWhereMaker {
        return _where
    }
    
    public var groupBy: IdbQueryGroupByMaker {
        return _groupBy
    }
    
    internal func addWhere(_ whereObject: IdbQueryWhereTest) {
        _whereObjects.append(whereObject)
    }
    
    internal func build() -> IdbQuery {
        _query.setup(select: _select,
                     from: _from,
                     wheres: _whereObjects,
                     groupBy: _groupBy)
        return _query
    }
}
