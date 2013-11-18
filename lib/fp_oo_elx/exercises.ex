
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
  defmodule Objects4 do
    import Dict
    def apply_message_to(class, object, message, args) do
      method = class |> get(:__instance_methods__) |> get(message)
      apply(method, [object|args])
    end  
    def make(class, args) do
      allocated   = []
      seeded      = allocated |> merge([__class_symbol__: get(class, :__own_symbol__)])
      apply_message_to(class, seeded, :add_instance_values, args)
    end
    def send_to(object, message, args // []) do
      class_name = object |> get(:__class_symbol__) 
      class      = apply(__MODULE__, class_name, [])
      apply_message_to(class, object, message, args)
    end
    def point() do 
      [
        __own_symbol__: :point,
        __instance_methods__: [
          class_name: &get(&1, :__class_symbol__),
          class: fn (_this) -> point end,
          add_instance_values: fn (this, x, y) ->
                                    this |> merge([x: x, y: y])
                               end,
          shift: fn (this, xinc, yinc) -> 
                      make(point, [get(this, :x) + xinc, get(this, :y) + yinc])
                 end
        ]
      ]
    end
  end
  defmodule Objects5 do
    import Dict
    def make(class, args) do
      allocated   = []
      seeded      = allocated |> merge([__class_symbol__: get(class, :__own_symbol__)])
      apply_message_to(class, seeded, :add_instance_values, args)
    end
    def send_to(object, message, args // []) do
      class_name = object |> get(:__class_symbol__) 
      class      = apply(__MODULE__, class_name, [])
      apply_message_to(class, object, message, args)
    end
    def point() do 
      [
        __own_symbol__: :point,
        __superclass_symbol__: :anything,
        __instance_methods__: [
          class: fn (_this) -> point end,
          add_instance_values: fn (this, x, y) ->
                                    this |> merge([x: x, y: y])
                               end,
          shift: fn (this, xinc, yinc) -> 
                      make(point, [get(this, :x) + xinc, get(this, :y) + yinc])
                 end
        ]
      ]
    end
    def anything do
      [
        __own_symbol__: :anything,
        __instance_methods__: [
          add_instance_values: fn(this) -> this end,
          class_name: &get(&1, :__class_symbol__),
          class: fn 
            (this) -> apply(__MODULE__, get(this, :__class_symbol__), [])
          end
        ] 
      ]
    end
    def class_instance_methods(class_symbol) do
      apply(__MODULE__, class_symbol, []) |> get(:__instance_methods__)
    end
    def class_symbol_above(class_symbol) do
      apply(__MODULE__, class_symbol, []) |> get(:__superclass_symbol__)
    end
    @doc """
      iex> lineage(:point)
      [:anything, :point]
    """
    def lineage(nil), do: []  
    def lineage(class_symbol) do
      [class_symbol|class_symbol |> class_symbol_above |> lineage] |> Enum.reverse
    end
    defp apply_message_to(class, object, message, args) do
      class |> method_cache |> get(message) |> apply([object|args])
    end  
    def method_cache(class) do
      import Enum
      class 
      |> get(:__own_symbol__)
      |> lineage
      |> map(&class_instance_methods/1)
      |> reduce(&Dict.merge(&2, &1))
    end
  end
  @doc """
    iex> factorial(5)
    120
  """
  def factorial(n) do
    case n do
      0 -> 1
      1 -> 1
      _ -> n*factorial(n-1)
    end
  end
  @doc """
    iex> factorial_acc(5)
    120
    iex> factorial_acc(0)
    1
  """
  def factorial_acc(n, acc // 1) do
    if n == 0 || n == 1 do
      acc
    else
      factorial_acc(n-1, n*acc)
    end
  end
end
