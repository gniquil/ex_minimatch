defmodule OneTwoStarTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3]
  import Enum, only: [filter: 2, sort: 1]

  IO.puts "Test cases for: onestar/twostar"

  test "{/*,*}" do
    assert ["/asdf/asdf/asdf"] |> filter(fn file -> match(file, "{/*,*}") end) |> sort == []
  end

  test "{/?,*}" do
    assert ["/a", "/b/b", "/a/b/c", "bb"] |> filter(fn file -> match(file, "{/?,*}") end) |> sort == ["/a", "bb"]
  end
end
