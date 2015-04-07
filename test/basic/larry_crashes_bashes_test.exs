defmodule LarryCrashesBashesTest do
  use ExUnit.Case, async: true

  import ExMinimatch
  import Enum, only: [sort: 1]

  # IO.puts "Test cases for: legendary larry crashes bashes"

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
    assert @files |> filter("/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\\1/") |> sort == []
  end

  test "/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\1/" do
    assert @files |> filter("/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\1/") |> sort == []
  end
end
