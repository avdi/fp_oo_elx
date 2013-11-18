
defmodule ExercisesTest do
  use ExUnit.Case
  import FpOoElx.Exercises
  test "my_apply" do
    assert(my_apply(&(&1 + &2), [1,2]) == 3)
  end
  
  test "my_apply2" do
    assert(my_apply2(&(&1 + &2), [1,2]) == 3)
  end
  test "1.18-3: add-squares" do
    assert(add_squares([1, 2, 5]) == 30)
  end
  test "1.18-4: bizarro-factorial" do
    assert(bizarro_factorial(5) == 120)
  end
  test "1.18-5: sequence functions" do
    # take
    assert(Enum.take([1,2,3], 2) == [1,2])
    # distinct
    assert(Enum.uniq([1,2,1,3,2]) == [1,2,3])
    # concat
    assert(Stream.concat([[1,2], [3,4]]) |> Enum.take(4) == [1,2,3,4])
    # repeat
    xs = Stream.repeatedly(fn -> "x" end)
    assert(xs |> Enum.take(3) == ["x", "x", "x"])
    
    # interleave
    # there appears to be no interleave. There's Enum.zip, which only
    # zips two collections, and isn't lazy(?).
  
    # drop
    assert((1..4) |> Enum.drop(2) == [3,4])
  
    # drop-last
    assert((1..4) |> Enum.slice(0..-2) == [1,2,3])
  
    # flatten
    assert(List.flatten([[1,2], [3,4]]) == [1,2,3,4])
  
    # partition
    assert((1..10) |> Enum.partition(&Integer.even?(&1)) == {[2,4,6,8,10], [1,3,5,7,9]})
  
    # every?
    assert([2,4,6] |> Enum.all?(&Integer.even?(&1)) == true)
    assert([1,4,6] |> Enum.all?(&Integer.even?(&1)) == false)
  
    # remove
    assert((1..10) |> Stream.reject(&Integer.even?/1) |> Enum.take(5) == [1,3,5,7,9])
  end
  test "1.18-6: prefix-of?" do
    assert(prefix_of?([1,2], [1,2,3,4]) == true)
    assert(prefix_of?([2,3], [1,2,3,4]) == false)
  end
  test "1.18-7: tails" do
    assert([1,2,3,4] |> tails == [[1,2,3,4], [2,3,4], [3,4], [4], []])
  end
  test "1.18-7: tails2" do
    assert([1,2,3,4] |> tails2 == [[1,2,3,4], [2,3,4], [3,4], [4], []])
  end
  defmodule TestObjects1 do
    import FpOoElx.Exercises.Objects1
    test "constructing a Point" do
      p = new_point(3,5)
      assert(x(p) == 3)
      assert(y(p) == 5)
    end
  end
  defmodule TestObjects2 do
    use ExUnit.Case
    import FpOoElx.Exercises.Objects2
    test "constructing a Point" do
      p = new_point(3,5)
      assert(x(p) == 3)
      assert(y(p) == 5)
      assert(class_of(p) == :point)
      p = shift(p, 7, -2)
      assert(x(p) == 10)
      assert(y(p) == 3)      
    end
    doctest FpOoElx.Exercises.Objects2
  end  
  defmodule TestObjects3 do
    use ExUnit.Case
    import FpOoElx.Exercises.Objects3
    doctest FpOoElx.Exercises.Objects3
  end  
  defmodule TestObjects4 do
    use ExUnit.Case
    import FpOoElx.Exercises.Objects4
    doctest FpOoElx.Exercises.Objects4
    test "class-based object creation" do
      import Dict
      p = make(point, [23, 42])
      assert(get(p, :x) == 23)
      assert(get(p, :y) == 42)
      p2 = send_to(p, :shift, [2, 3])
      assert(get(p2, :x) == 25)
      assert(get(p2, :y) == 45)
    end
    test "class and class name" do
      p = make(point, [23, 42])
      assert(send_to(p, :class) == point)
      assert(send_to(p, :class_name) == :point)
    end
  end  
  defmodule TestObjects5 do
    use ExUnit.Case
    import FpOoElx.Exercises.Objects5
    doctest FpOoElx.Exercises.Objects5
    test "class-based object creation" do
      import Dict
      p = make(point, [23, 42])
      assert(get(p, :x) == 23)
      assert(get(p, :y) == 42)
      p2 = send_to(p, :shift, [2, 3])
      assert(get(p2, :x) == 25)
      assert(get(p2, :y) == 45)
    end
    test "class and class name" do
      p = make(point, [23, 42])
      assert(send_to(p, :class) == point)
      assert(send_to(p, :class_name) == :point)
    end
    
  end  
  doctest FpOoElx.Exercises
end
