import Foundation

public class IdbQueryWhereMaker {
    
    private let maker: IdbQueryMaker
    
    init(_ maker: IdbQueryMaker) {
        self.maker = maker
    }
    
    public func tag(_ tag: String) -> IdbQueryWhereTagTest {
        return IdbQueryWhereTagTest(maker: maker, tag: tag)
    }
    
    public var time: IdbQueryWhereTimeTest {
        return IdbQueryWhereTimeTest(maker: maker)
    }
    
    public var value: IdbQueryWhereValueTest {
        return IdbQueryWhereValueTest(maker: maker)
    }
}
