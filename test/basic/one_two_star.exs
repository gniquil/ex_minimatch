defmodule OneTwoStarTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3, prepare: 1, fnmatch: 2, fnfilter: 2]
  import Enum, only: [sort: 1]

  IO.puts "Test cases for: onestar/twostar"

  test "{/*,*}" do
    matcher = prepare("{/*,*}")

    # assert matcher.regex == Regex.compile!("^(?:\\/(?!\\.)(?=.)[^/]*?|(?!\\.)(?=.)[^/]*?)$")

    assert ["/asdf/asdf/asdf"] |> fnfilter(matcher) |> sort == []
  end

  test "{/?,*}" do
    matcher = prepare("{/?,*}")

    # assert matcher.regex == Regex.compile!("^(?:\\/(?!\\.)(?=.)[^/]|(?!\\.)(?=.)[^/]*?)$")

    assert ["/a", "/b/b", "/a/b/c", "bb"] |> fnfilter(matcher) |> sort == ["/a", "bb"]
  end
end
