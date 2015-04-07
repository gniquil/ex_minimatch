defmodule LarryCrashesBashesTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3, compile: 1, fnmatch: 2, fnfilter: 2]
  import Enum, only: [sort: 1]

  IO.puts "Test cases for: legendary larry crashes bashes"

  @files [
    "a",
    "b",
    "c",
    "d",
    "abc",
    "abd",
    "abe",
    "bb",
    "bcd",
    "ca",
    "cb",
    "dd",
    "de",
    "bdir/",
    "bdir/cfile"
  ]

  test "/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\\1/" do
    matcher = compile("/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\\1/")

    # assert matcher.regex == Regex.compile!("^(?:\\/\\^root:\\/\\{s\\/(?=.)\\^[^:][^/]*?:[^:][^/]*?:\\([^:]\\)[^/]*?\\.[^/]*?\\$\\/1\\/)$")

    assert @files |> fnfilter(matcher) |> sort == []
  end

  test "/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\1/" do
    matcher = compile("/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\1/")

    # TODO, find out what the unicode x{0001} means
    # assert matcher.regex == Regex.compile!("^(?:\\/\\^root:\\/\\{s\\/(?=.)\\^[^:][^/]*?:[^:][^/]*?:\\([^:]\\)[^/]*?\\.[^/]*?\\$\\/\x{0001}\\/)$")

    # assert matcher.regex == Regex.compile!("^(?:\\/\\^root:\\/\\{s\\/(?=.)\\^[^:][^/]*?:[^:][^/]*?:\\([^:]\\)[^/]*?\\.[^/]*?\\$\\/\1\\/)$")

    assert @files |> fnfilter(matcher) |> sort == []
  end
end
