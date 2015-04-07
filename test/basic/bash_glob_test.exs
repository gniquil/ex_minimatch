defmodule BashGlobTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3, compile: 1, fnmatch: 2, fnfilter: 2]
  import Enum, only: [sort: 1]

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
    matcher = compile("a*")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?)$")

    assert @files |> fnfilter(matcher) |> sort == ["a", "abc", "abd", "abe"]
  end

  test "X*" do
    matcher = compile("X*")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)X[^/]*?)$")

    assert @files |> fnfilter(matcher) |> sort == []
  end

  # isaacs: Slightly different than bash/sh/ksh
  # \\* is not un-escaped to literal "*" in a failed match,
  # but it does make it get treated as a literal star

  test "\\*" do
    matcher = compile("\\*")

    # assert matcher.regex == Regex.compile!("^(?:\\*)$")

    assert @files |> fnfilter(matcher) |> sort == []
  end

  test "\\**" do
    matcher = compile("\\**")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)\\*[^/]*?)$")

    assert @files |> fnfilter(matcher) |> sort == []
  end

  test "\\*\\*" do
    matcher = compile("\\*\\*")

    # assert matcher.regex == Regex.compile!("^(?:\\*\\*)$")

    assert @files |> fnfilter(matcher) |> sort == []
  end

  test "b*/" do
    matcher = compile("b*/")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)b[^/]*?\\/)$")

    assert @files |> fnfilter(matcher) |> sort == ["bdir/"]
  end

  test "c*" do
    matcher = compile("c*")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)c[^/]*?)$")

    assert @files |> fnfilter(matcher) |> sort == ["c", "ca", "cb"]
  end

  test "**" do
    matcher = compile("**")

    # assert matcher.regex == Regex.compile!("^(?:(?:(?!(?:\\/|^)\\.).)*?)$")

    assert @files |> fnfilter(matcher) |> sort == @files |> sort
  end

  test "\\.\\./*/" do
    matcher = compile("\\.\\./*/")

    # assert matcher.regex == Regex.compile!("^(?:\\.\\.\\/(?!\\.)(?=.)[^/]*?\\/)$")

    assert @files |> fnfilter(matcher) |> sort == []
  end

  test "s/\\..*//" do
    matcher = compile("s/\\..*//")

    # assert matcher.regex == Regex.compile!("^(?:s\\/(?=.)\\.\\.[^/]*?\\/)$")

    assert @files |> fnfilter(matcher) |> sort == []
  end
end
