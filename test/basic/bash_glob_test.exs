defmodule BashGlobTest do
  use ExUnit.Case, async: true

  import ExMinimatch
  import Enum, only: [sort: 1]

  # IO.puts "Test cases for: http://www.bashcookbook.com/bashinfo/source/bash-1.14.7/tests/glob-test"

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
    assert @files |> filter("a*") |> sort == ["a", "abc", "abd", "abe"]
  end

  test "X*" do
    assert @files |> filter("X*") |> sort == []
  end

  # isaacs: Slightly different than bash/sh/ksh
  # \\* is not un-escaped to literal "*" in a failed match,
  # but it does make it get treated as a literal star

  test "\\*" do
    assert @files |> filter("\\*") |> sort == []
  end

  test "\\**" do
    assert @files |> filter("\\**") |> sort == []
  end

  test "\\*\\*" do
    assert @files |> filter("\\*\\*") |> sort == []
  end

  test "b*/" do
    assert @files |> filter("b*/") |> sort == ["bdir/"]
  end

  test "c*" do
    assert @files |> filter("c*") |> sort == ["c", "ca", "cb"]
  end

  test "**" do
    assert @files |> filter("**") |> sort == @files |> sort
  end

  test "\\.\\./*/" do
    assert @files |> filter("\\.\\./*/") |> sort == []
  end

  test "s/\\..*//" do
    assert @files |> filter("s/\\..*//") |> sort == []
  end
end
