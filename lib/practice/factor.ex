defmodule Practice.Factor do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def factor(x) do
    find_factors(x, 2, [])
  end

  def get_ns(x, n, ns) do
    if rem(x, n) == 0 do
      get_ns(div(x, n), n, [n|ns])
    else
      {x, ns}
    end
  end

  def find_factors(x, p, ps) do
    cond do
      x == 1 -> ps
      rem(x, p) == 0 ->
        {x, ps} = get_ns(x, p, ps)
        find_factors(x, p + 1, ps)
      true -> find_factors(x, p + 1, ps)
    end
  end

end
