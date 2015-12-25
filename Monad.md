# Monad

The concept of Monad come from a branch of mathematics called Category Theory. In software design, basically a monad reference as a design pattern, it was formally introduced by Haskell 1.3 (May 1996) to solve the problematic of I/O, in order to find a way to compose input and output function and handle error cases.

**Monad** is a **Container** with a mechanism of **Function Composition**! The first part of this article is about Monoid and how to build function composition, and the second part is about Monad and how to apply function composition to a container.

All the code example in this article will use the Swift 2.0 syntax, but they can be rewriten in all the language that have lambda and generic.

## Monoid 

In category theory, a monoid is an object that have the following property:

- An operation that compose two elements of the same type.
- A zero element, also called unit.

And following the rules of:

- Associativity
- Neutral element

The definition is nice, but let's have an example, using Integer as type and Multiplication as operation.

- Operation: *
- Unit: 1
- Associativity: `(a * b) * c == a * (b * c)`
- Neutral element: `1 * n == n * 1 == n`

Example:

- Associativity: `(42 * 4) * 2 == 42 * (4 * 2) == 336`
- Neutral element: `1 * 47 == 47 * 1 == 47`

We can see here that Multiplication of Integer is a Monoid.

Here below the protocol for Monoid of any types, not only Integer, but any type that we can use or define in swift.

```Swift
protocol Monoid {
    typealias ItemType
    var unit: ItemType { get }
    
    func compose(left left: ItemType, right: ItemType) -> ItemType
}
```

 Now, because in Swift functions are first-class citizens. Let's define a Monoid that use function as type "T -> T".

- Associativity: compose(compose(f,g),h) == compose(f,compose(g,h))
- Neutral element: compose(unit,f) == compose(f, unit) == f

```Swift
struct MonoidOfFunction<T>: Monoid {
    let unit: T -> T = { $0 }
    
    func compose(left f: T -> T, right g: T -> T) -> T -> T {
        return { g(f($0)) }
    }
}
```
The unit function is simply a closure that return is input param.
The compose method is creating a closure that return executed the left function with the first input and give the result to the right function and return it. This is **function composition**.

```Swift
m.compose(f: m.compose(f: {$0 * 20}, g: {$0 / 5}), g: {$0 + 75})(47)
```

A monoid does not allow us to transform a Int in a String, for this we will have slighty diferent implementation, called Monoidal Category, is the same idea, but we allow ourself to change the return type of the operands.

```Swift
struct MonoidalCategoryOfFunction<T>: Monoid {
    let unit: T -> T = { $0 }// Or Idenity

    func compose<U, V>(left f: T -> U, right g: U -> V) -> T -> V {
        return { g(f($0)) }
    }
}
```

Now that we know how to compose function, let's what is a Monad.

## Monad

A monad is a container of a type, that help us to implement programming concept, like I/O, error management, concurency, continuation and many more. In this article we will describe the general concept of monad and we will explain the implementation of some of theses concept in a future article. 

Monad like Monoid should also obey to the same property of associativty and neutral element, these properties are called *monadic laws*. But now on, in this article we will omit to explain the unit element for function, because it will always be a function that return the input value.

```Swift
protocol Monad {
    typealias MonadType
    var value: MonadType { get }
    
    func compose(left left: MonadType -> Self, right: MonadType -> Self) -> MonadType -> Self
}
```
This looks, familiar now that we know what a monoid is, but first big **WARNING** do not confuse unit monoid and value of Monad. 

- value: is the value contain in the Monad, remember that we said Monad is container.
- compose: is a method that compose 2 function and return a function.

Now let see an implemention of Monad.


```Swift
    static func compose<T, U, V>(left f: T -> Monad<U>, right g: U -> Monad<V>) -> T -> Monad<V> {
        return { g(f($0).value) }
    }
```
We take the result of the first closure, get the value and we pass it to the second function. 

But in practice the left closure is always a closure calling the constructor of the monad with the value passed in params. Like the follwing:

```Swift
{ Monad(value: $0) }
```

So we will omit the first closure and replace it by the monad.

```Swift
    static func compose<U, V>(m: Monad<U>, right g: U -> Monad<V>) -> Monad<V> {
        return g(m.value)
    }
```

Now that we have a object one side and a function on the other let's rewrite in OOP fashion. That will allow us, to do chaining of function.

```Swift
struct Monad {
    func compose<V>(g: W -> Monad<V>) -> Monad<V> {
        return g(self.value)
    }
}
```
    
We can do better and move the responsability to initialize the monad inside the function composition and only have the effect in the closure.

```Swift
struct Monad {
    func compose<V>(g: W -> V) -> Monad<V> {
        return Monad<V>(value: g(self.value))
    }
}
```

So now we can do some nice function chaining/composition. This implementation of monad, is called Identity Monad and generally the compose function is called bind. And with we can do the following kind of chaining:

```Swift
IdentityMonad(value: "Hello World")
    .bind({$0.stringByReplacingOccurrencesOfString("World", withString: "Everybody!")})
    .bind(print)

IdentityMonad(value: 47).bind{"\($0)"}.bind {Array($0)} == ["4", "7"]
```
With this article you know what are the rules and properties that define a Monad, most of the flatMap implementation are monadic, but having a flatMap method in your class does not automatically define you as a Monad.
We will see in a future articles what Monad it can be usefull for and diferent implementation to do I/O or error handling. 

*Spoiler: Optional is a Monad ;)*


## References 
- <http://en.wikibooks.org/wiki/Haskell/Monoids>
- <https://blog.safaribooksonline.com/2013/05/15/monoids-for-programmers-a-scala-example/>
- <http://research.microsoft.com/en-us/um/people/simonpj/papers/history-of-haskell/history.pdf>
- Brian Beckman: Don't fear the Monad <https://www.youtube.com/watch?v=ZhuHCtR3xq8>
- Monads and Gonads Presented by Douglas Crockford <https://www.youtube.com/watch?v=b0EF0VTs9Dc>
- Erik Meijer: Functional Programming <https://www.youtube.com/watch?v=z0N1aZ6SnBk>
- <http://en.wikipedia.org/wiki/Monad_(functional_programming)>