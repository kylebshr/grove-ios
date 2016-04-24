##Mapper

Object mapping made easy

Filling an NSObject with values is as easy as pie.

``` swift
class Person {
    var name: String = ""
    var age: Int = 0
}

let subject = Person.new()
subject.fill(["name":"Batman", "age":55])
```

Like that wasn't easy enough, Mapper also adds a method to initialise objects using a dictionary.

```swift
let subject = Person.initWithDictionary(["name":"Batman", "age":55])
```

Mapper can also serve up a dictionary representation of any object that you throw at it.
``` swift
let objectDictionary: NSDictionary = subject.dictionaryRepresentation()
```

## Contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create pull request
