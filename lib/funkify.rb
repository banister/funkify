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
    head, *tail = args
    head = _procify(head)
    if args.size <= 2
      ->(*xs) { head.(_procify(tail[0]).(*xs)) }
    else
      ->(*xs) { head.(compose(*tail)) }
    end
  end

  def _procify(obj)
    case obj
    when Symbol
      method(obj).to_proc
    else
      obj.to_proc
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
      -> (*args) do
        b = instance_exec(&block).curry
        args.empty? ? b : b[*args]
      end
    end
  end
end
