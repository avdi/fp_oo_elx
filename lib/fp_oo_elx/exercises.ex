
defmodule FpOoElx.Exercises do
  def my_apply(func, sequence) do
    code = quote do
      unquote(func).(unquote_splicing(sequence))
    end
    {result, _} = Code.eval_quoted(code)
    result
  end
  def my_apply2(func, sequence) do
    {result, _} = Code.eval_quoted({{:., [], [func]}, [], sequence})
    result
  end
  def add_squares([n|ns]), do: n*n + add_squares(ns)
  def add_squares([]), do: 0
  def bizarro_factorial(n) do
    (1..n) |> Enum.reduce(&(&1 * &2))
  end
end
