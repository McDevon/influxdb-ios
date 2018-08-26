import Foundation

public class IdbQueryMaker {
    
    private let _query = IdbQuery()
    private lazy var _select = IdbQuerySelectMaker(self)
    private lazy var _where = IdbQueryWhereMaker(self)
    private var _from = [String]()
    
    private var whereObjects = [IdbQueryWhereTest]()
    
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
    
    internal func addWhere(_ whereObject: IdbQueryWhereTest) {
        whereObjects.append(whereObject)
    }
    
    internal func build() -> IdbQuery {
        _query.setup(select: _select, from: _from, wheres: whereObjects)
        return _query
    }
}
