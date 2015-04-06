defmodule LarryCrashesBashesTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3]
  import Enum, only: [filter: 2, sort: 1]

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
    assert @files |> filter(fn file -> match(file, "/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\\1/") end) |> sort == []
  end

  test "/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\1/" do
    assert @files |> filter(fn file -> match(file, "/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\1/") end) |> sort == []
  end
end
