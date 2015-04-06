defmodule BashGlobTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3]
  import Enum, only: [filter: 2, sort: 1]

  IO.puts "Test cases for: http://www.bashcookbook.com/bashinfo/source/bash-1.14.7/tests/glob-test"

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

  test "a*" do
    assert @files |> filter(fn file -> match(file, "a*") end) |> sort == ["a", "abc", "abd", "abe"]
  end

  test "X*" do
    assert @files |> filter(fn file -> match(file, "X*") end) |> sort == []
  end

  # isaacs: Slightly different than bash/sh/ksh
  # \\* is not un-escaped to literal "*" in a failed match,
  # but it does make it get treated as a literal star

  test "\\*" do
    assert @files |> filter(fn file -> match(file, "\\*") end) |> sort == []
  end

  test "\\**" do
    assert @files |> filter(fn file -> match(file, "\\**") end) |> sort == []
  end

  test "\\*\\*" do
    assert @files |> filter(fn file -> match(file, "\\*\\*") end) |> sort == []
  end

  test "b*/" do
    assert @files |> filter(fn file -> match(file, "b*/") end) |> sort == ["bdir/"]
  end

  test "c*" do
    assert @files |> filter(fn file -> match(file, "c*") end) |> sort == ["c", "ca", "cb"]
  end

  test "**" do
    assert @files |> filter(fn file -> match(file, "**") end) |> sort == @files |> sort
  end

  test "\\.\\./*/" do
    assert @files |> filter(fn file -> match(file, "\\.\\./*/") end) |> sort == []
  end

  test "s/\\..*//" do
    assert @files |> filter(fn file -> match(file, "s/\\..*//") end) |> sort == []
  end
end
