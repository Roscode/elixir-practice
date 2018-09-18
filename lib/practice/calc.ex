defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.trim
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> infix_to_postfix
    |> evaluate

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end

  @doc """
  tagged tokens are 2 or 3 tuples of the following forms:
  {:num, float}
  {:op, operator, precedence}
  """
  def tag_tokens(tokens) do
    Enum.map(tokens, fn
      "+" -> {:op, "+", 1}
      "-" -> {:op, "-", 1}
      "*" -> {:op, "*", 2}
      "/" -> {:op, "/", 2}
      x -> {:num, parse_float(x)}
    end)
  end

  def infix_to_postfix(tagged_tokens) do
    # scan through the tokens
    {expr, stack} = Enum.reduce(tagged_tokens, {[], []}, &infix_to_postfix/2)
    # clear any remaining ops from the stack
    stack
    |> Enum.reduce(expr, fn op, acc -> [op | acc] end)
    |> Enum.reverse()
  end

  def infix_to_postfix(token, {expr, stack}) do
    case {token, stack} do
      {{:num, _}, _} ->
        {[token | expr], stack}

      {{:op, _, _}, []} ->
        {expr, [token | stack]}

      {{:op, _, token_p}, [head | tail]} ->
        {:op, _, stack_p} = head

        if token_p <= stack_p do
          infix_to_postfix(token, {[head | expr], tail})
        else
          {expr, [token | stack]}
        end
    end
  end

  def evaluate(postfix_expr) do
    hd Enum.reduce(postfix_expr, [], fn
      {:num, value}, stack ->
        [value | stack]

      {:op, op, _}, [rhs | [lhs | stack]] ->
        case op do
          "+" -> [lhs + rhs | stack]
          "-" -> [lhs - rhs | stack]
          "*" -> [lhs * rhs | stack]
          "/" -> [lhs / rhs | stack]
        end
    end)
  end
end
