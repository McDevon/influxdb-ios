# InfluxDB iOS Library
A small Swift library and query DSL for InfluxDB

This project is at its current state by no means a complete solution for using InfluxDB on iOS. The number of supported features in especially the query DSL is still very small. However, it does a good job for some small scale use cases.

Ideas and contributions for further improvements are welcome.

## Usage

Setup server and database info

```swift
InfluxDb.setup(url: "https://mydomain.com:8086", database: "mydatabase")
```

Make a query and read the results

```swift
let lowestLevelOfDayQuery = InfluxDb.makeQuery { q in
    q.select.min()
     .from("water_level")
     .where.tag("sensor").equals("tank1")
     .where.time.greaterThan(Date().addingTimeInterval(-24 * 60 * 60))
}

InfluxDb.query(lowestLevelOfDayQuery) { results in
    guard let firstResult = results?.first,
        let lowestTime = firstResult.dateResults(forSeries: "water_level")?.first,
        let lowestValue = firstResult.doubleResults(forSeries: "water_level")?.first else { return 
    print("Lowest water level in tank 1 during last 24 hours: \(lowestValue) at \(lowestTime.description(with: Locale.current))")
}
```