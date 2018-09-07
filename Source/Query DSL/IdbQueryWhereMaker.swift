import Foundation

public class IdbQueryWhereMaker {
    
    private let _maker: IdbQueryMaker
    
    init(_ maker: IdbQueryMaker) {
       _maker = maker
    }
    
    public func tag(_ tag: String) -> IdbQueryWhereTagTest {
        return IdbQueryWhereTagTest(maker: _maker, tag: tag)
    }
    
    public var time: IdbQueryWhereTimeTest {
        return IdbQueryWhereTimeTest(maker: _maker)
    }
    
    public var value: IdbQueryWhereValueTest {
        return IdbQueryWhereValueTest(maker: _maker)
    }
}
