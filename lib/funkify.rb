require "funkify/version"

module Funkify
  def self.included(klass)
    klass.extend ClassMethods
  end

  class ::Proc
    def +(other)
      Funkify.compose(self, other)
    end
  end

  class ::Symbol
    def +(other)
      Funkify.compose(self, other)
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
      method(:obj).to_proc
    else
      obj.to_proc
    end
  end

  module ClassMethods
    def auto_curry(*names)
      if names.empty?
        in_use = nil
        define_singleton_method(:method_added) do |name|
          return if in_use
          in_use = true
          auto_curry name
          in_use = false
        end
        return
      end

      names.each do |name|
        m = instance_method(name)
        curried_method = nil
        define_method(name) do |*args|
          curried_method ||= m.bind(self).to_proc.curry
          curried_method[*args]
        end
      end
    end
  end
end
