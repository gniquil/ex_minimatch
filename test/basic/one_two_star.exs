defmodule OneTwoStarTest do
  use ExUnit.Case, async: true

  import ExMinimatch
  import Enum, only: [sort: 1]

  # IO.puts "Test cases for: onestar/twostar"

  test "{/*,*}" do
    assert ["/asdf/asdf/asdf"] |> filter("{/*,*}") |> sort == []
  end

  test "{/?,*}" do
    assert ["/a", "/b/b", "/a/b/c", "bb"] |> filter("{/?,*}") |> sort == ["/a", "bb"]
  end
end
