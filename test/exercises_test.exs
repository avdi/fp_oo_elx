
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
  end
end
