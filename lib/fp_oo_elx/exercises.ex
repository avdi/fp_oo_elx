
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
  def prefix_of?(candidate, sequence) do
    import Enum
    size   = count(candidate)
    subseq = sequence |> take(size)
    candidate == subseq
  end
  def tails([_|xs] = sequence), do: [sequence|tails(xs)]
  def tails([]), do: [[]]
  def tails2(seq) do
    import Enum
    0..count(seq) |> map(&drop(seq, &1))
  end
  defmodule Objects1 do
    import Dict
    def new_point(x, y), do: [x: x, y: y]
    def x(point), do: get(point, :x)
    def y(point), do: get(point, :y)
  end
  defmodule Objects2 do
    import Dict
    def new_point(x, y), do: [x: x, y: y, __class_symbol__: :point]
    def x(this), do: get(this, :x)
    def y(this), do: get(this, :y)   
    def class_of(object), do: get(object, :__class_symbol__)
    def shift(this, xinc, yinc), do: new_point(x(this) + xinc, y(this) + yinc)
    @doc """
    ## Examples:
        iex> p1 = new_point(3, 7)
        iex> p2 = new_point(8, -3)
        iex> p3 = add(p1, p2)
        iex> x(p3)
        11
        iex> y(p3)
        4
    """
    def add(p1, p2), do: shift(p1, x(p2), y(p2))
    @doc """
    ## Examples
        iex> p = make(point, [3, 5])
        iex> class_of(p)
        :point
        iex> x(p)
        3
        iex> y(p)
        5
    """
    defmacro make(class, args) do
      {classname,_,_} = class
      constructor = binary_to_atom("new_#{classname}")
      quote do
        unquote(constructor)(unquote_splicing(args))
      end
    end
    @doc """
    ## Examples
        iex> p = make2(:point, [3, 5])
        iex> class_of(p)
        :point
        iex> x(p)
        3
        iex> y(p)
        5
    """
    def make2(class, args) do
      constructor = :"new_#{class}"
      code = {constructor, [], args}
      {result, _} = Code.eval_quoted(code, binding, delegate_locals_to: __MODULE__)
      result
    end
  end
  defmodule Objects3 do
    import Dict
    defmacro make(class, args) do
      {classname,_,_} = class
      constructor = binary_to_atom("new_#{classname}")
      quote do
        unquote(constructor)(unquote_splicing(args))
      end
    end
    @doc """
    ## Examples
        iex> p = make(point, [3, 5])
        iex> p2 = send_to(p, :shift, [2,4])
        iex> Dict.get(p2, :x)
        5
        iex> Dict.get(p2, :y)
        9 
    """
    def send_to(object, message, args // []) do
      method_table = get(object, :__methods__)
      method       = get(method_table, message)
      apply(method, [object|args])
    end
    @doc """
    iex> p1 = make(point, [3,5])
    iex> p2 = make(point, [-2,3])
    iex> p3 = send_to(p1, :add, [p2])
    iex> send_to(p3, :x)
    1
    iex> send_to(p3, :y)
    8
    """
    def new_point(x, y) do
      [
        x: x, 
        y: y, 
        __class_symbol__: :point,
        __methods__: [
          class: &get(&1, :__class_symbol__),
          shift: fn 
                   (this, xinc, yinc) -> new_point(get(this, :x) + xinc, get(this, :y) + yinc)
                 end,
          x: &get(&1, :x),
          y: &get(&1, :y),
          add: fn (this, other) -> send_to(this, :shift, [send_to(other, :x), send_to(other, :y)]) end
        ]
      ]
    end  
  end
end
