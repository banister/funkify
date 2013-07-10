# Funkify

**(c) Copyright 2013, Epitron**

_Haskell-style partial application and composition for Ruby methods_

## Usage

```ruby
class MyFunkyClass
  include Funkify

  def add(x, y)
    x + y
  end

  # we make a specific method autocurried using the auto_curry method
  auto_curry :add

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

When a method supports autocurrying it can still be invoked normally (if all parameters are provided) however if less than the required number are given a `Proc` is returned
with the given parameters partially applied:

```ruby
funky = MyFunkyClass.new

funky.add(1, 2) #=> This works normally and returns 3
add_1 = funky.add(1) #=> The `1` is partially applied and a `Proc` is returned
add_1.(2) #=> We invoke that `Proc` with the remaining argument and the final result (`3`) is returned.
```

We can also compose methods using `+`:

```ruby
add_1_and_multiply_by_5 = funky.mult(5) + funky.add(1)
add_1_and_multiply_by_5.(10) #=> 55

# We can even further compose the above with another method:

(funky.negate + add_1_and_multiply_by_5).(10) #=> -55
```

Other examples:

Add 10 to every item in an Enumerable:

```ruby
(1..5).map(&funky.add(10)) #=> [10, 12, 13, 14, 15]
```

Multiply by 10 and negate every item in an Enumerable:

```ruby
(1..5).map &(funky.negate + funky.mult(10)) => [-10, -20, -30, -40, -50]
```

## Installation

Add this line to your application's Gemfile:

    gem 'funkify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install funkify

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
