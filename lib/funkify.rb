require "funkify/version"

module Funkify
  def self.included(klass)
    klass.extend ClassMethods
  end

  class ::Proc
    def *(other)
      Funkify.compose(self, other)
    end

    def |(other)
      Funkify.compose(other, self)
    end

    def >=(other)
      other.(*self.())
    end

    def self.compose(one, other)

    end
  end

  module_function

  def curry(obj, *args)
    case obj
    when Symbol
      method(obj).to_proc.curry[*args]
    else
      obj.curry(*args)
    end
  end

  def pass(*xs)
    -> { xs }
  end
  public :pass

  def compose(*args)
    raise ArgumentError.new('#compose should be used with more than 1 argument') if args.size <= 1

    compacted = args.compact
    head = compacted.shift.to_proc

    compacted.inject(head) do |x,y| 
      tail = y.to_proc
      ->(*xs) { x.(tail.(*xs)) }
    end
  end

  def self.auto_curry_all_methods(receiver)
    in_use = nil
    receiver.define_singleton_method(:method_added) do |name|
      return if in_use
      in_use = true
      receiver.auto_curry name
      in_use = false
    end
  end

  def self.auto_curry_some_methods(names, receiver)
    names.each do |name|
      m = receiver.instance_method(name)
      curried_method = nil

      receiver.class_eval do
        define_method(name) do |*args|
          curried_method ||= m.bind(self).to_proc.curry
          curried_method[*args]
        end
      end
    end
  end

  module ClassMethods
    def auto_curry(*names)
      if names.empty?
        Funkify.auto_curry_all_methods(self)
      else
        Funkify.auto_curry_some_methods(names, self)
      end
    end

    def point_free(&block)
      ->(*args) do
        b = instance_exec(&block).curry
        args.empty? ? b : b[*args]
      end
    end
  end
end
