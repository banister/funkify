require 'spec_helper'

describe Funkify do
  describe "auto_curry method" do
    before do
      @c = Class.new do
        include Funkify

        def alpha(x) x end
        def beta(x) x end
        auto_curry :beta

        def epsilon(x) x end

        def gamma(x) x end
        def zeta(x) x end
        auto_curry :gamma, :zeta

        auto_curry

        def harry(x) x end
        def joseph(x) x end
      end.new
    end

    it 'does not autocurry unselected methods' do
      should.raise(ArgumentError) { @c.alpha }
    end

    it 'curries one method, when specified' do
      @c.beta.is_a?(Proc).should == true
    end

    it 'does not curry methods after auto_curry used to curry a single method' do
      should.raise(ArgumentError) { @c.epsilon }
    end

    it 'curries multiple methods when auto_curry given multiple args' do
      @c.gamma.is_a?(Proc).should == true
      @c.zeta.is_a?(Proc).should == true
    end

    it 'curries all methods after a call to auto_curry with no args' do
      @c.harry.is_a?(Proc).should == true
      @c.joseph.is_a?(Proc).should == true
    end
  end

  describe "currying behaviour" do
    before do
      @c = Class.new do
        include Funkify

        auto_curry

        def add(x, y, z)
          x + y + z
        end
      end.new
    end

    it 'invokes methods normally when all parameters are provided' do
      @c.add(1, 2, 3).should == 6
    end

    it 'returns a curried Proc when less than required args are given' do
      @c.add.is_a?(Proc).should == true
      @c.add(1).is_a?(Proc).should == true
      @c.add(1, 2).is_a?(Proc).should == true
    end

    it 'allows curried procs to be completed when the full args are provided successively' do
      @c.add(1).(2).(3).should == 6
      @c.add(1).(2, 3).should == 6
      @c.add(1, 2).(3).should == 6
    end

    it 'raises an exception when too many args passed to curried Proc'  do
      should.raise(ArgumentError) { @c.add(1, 2).(3, 4) }
    end
  end

  describe "composition" do
    before do
      @c = Class.new do
        include Funkify

        auto_curry

        def add(x, y)
          x + y
        end

        def mult(x, y)
          x * y
        end

        def negate(x)
          -x
        end

        def plus_1(x)
          x + 1
        end
      end.new
    end

    it 'returns a new Proc when composing methods' do
      (@c.negate + @c.plus_1).is_a?(Proc).should == true
    end

    it 'invokes composed methods in the correct order (right-to-left)' do
      (@c.negate + @c.plus_1).(5).should == -6
    end

    it 'can compose partially applied methods' do
      (@c.add(5) + @c.mult(2)).(5).should == 15
    end

    it 'can compose multiple methods' do
      (@c.negate + @c.add(5) + @c.mult(5)).(5).should == -30
    end
  end
end
