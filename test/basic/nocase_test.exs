defmodule NocaseTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3, compile: 2, fnmatch: 2, fnfilter: 2]
  import Enum, only: [sort: 1]

  IO.puts "Test cases for: nocase"

  test "XYZ" do
    matcher = compile("XYZ", %{nocase: true})

    # assert matcher.regex == Regex.compile!("^(?:(?=.)XYZ)$", "i")

    assert ["xYz", "ABC", "IjK"] |> fnfilter(matcher) |> sort == ["xYz"]
  end

  test "ab*" do
    matcher = compile("ab*", %{nocase: true})

    # assert matcher.regex == Regex.compile!("^(?:(?=.)ab[^/]*?)$", "i")

    assert ["xYz", "ABC", "IjK"] |> fnfilter(matcher) |> sort == ["ABC"]
  end

  test "[ia]?[ck]" do
    matcher = compile("[ia]?[ck]", %{nocase: true})

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[ia][^/][ck])$", "i")

    assert ["xYz", "ABC", "IjK"] |> fnfilter(matcher) |> sort == ["ABC", "IjK"]
  end
end
