# Funkify

_Haskell-style partial application and composition for Ruby methods_

Function composition when used in conjunction with partial application can yield exceptionally concise code, often more concise than the idiomatic Ruby. Check out the links
below for further explanations of these features and examples of their use in Haskell:

[Partial application in Haskell](http://www.haskell.org/haskellwiki/Partial_application)<br>
[Function composition in Haskell](http://www.haskell.org/haskellwiki/Function_composition)<br>
[Currying in Haskell](http://www.haskell.org/haskellwiki/Currying)

Also, watch [this video](http://www.youtube.com/watch?v=m3svKOdZijA) to learn about some of the cool things you can do with
function composition and partial application (the video is in Javascript but the ideas still apply to Ruby with Funkify)

## Usage

### Autocurrying

In order for a Ruby method to be amenable to partial application and composition it must first be autocurried:

```ruby
class MyFunkyClass
  include Funkify

  # we make a specific method autocurried using the auto_curry method (Here with Ruby 2.0 decorator syntax)
  auto_curry def add(x, y)
    x + y
  end

  # alternatively, if we invoke auto_curry without a parameter
  # then all subsequent methods will be autocurried
  auto_curry

  def mult(x, y)
    x * y
  end

  def negate(x)
    -x
  end
end
```

### Partial application and currying

When a method supports autocurrying it can still be invoked normally (if all parameters are provided) however if less than the required number are given a `Proc` is returned
with the given parameters partially applied:

```ruby
funky = MyFunkyClass.new

funky.add(1, 2) #=> This works normally and returns 3
add_1 = funky.add(1) #=> The `1` is partially applied and a `Proc` is returned
add_1.(2) #=> 3 (We invoke that `Proc` with the remaining argument)
```

### Function composition

We compose methods using the `*` and `|` operators.

`*` composes right to left, this is the standard way to compose functions found in languages like Haskell:
```ruby
(mult(5) * add(1)).(10) #=> 55

# We can further compose the above with another method:
(negate * mult(5) * add(1)).(10) #=> -55
```

`|` composes left to right, like a shell pipeline:
```ruby
(mult(5) | add(1) | negate).(3) #=> -16
```

As a cute bonus, we can inject values from the left into a pipeline with the `pass` method together with the `>=` (pipeline operator) ([see more](http://showterm.io/47f46234281cf2c25f44a#fast)):
```ruby
pass(3) >= mult(5) | add(1) | negate #=> -16
```

#### Other examples:

Add 10 to every item in an Enumerable:

```ruby
(1..5).map &funky.add(10) #=> [11, 12, 13, 14, 15]
```

Multiply by 10 and negate every item in an Enumerable:

```ruby
(1..5).map &(funky.negate * funky.mult(10)) #=> [-10, -20, -30, -40, -50]
```

## Installation

Add this line to your application's Gemfile:

    gem 'funkify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install funkify

## Dedication

This library was inspired in part by stimulating conversations with [epitron](https://github.com/epitron) on Freenode.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
