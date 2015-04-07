defmodule CharacterClassesTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3, compile: 1, fnmatch: 2, fnfilter: 2]
  import Enum, only: [sort: 1]

  IO.puts "Test cases for: character classes"

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

  test "[a-c]b*" do
    matcher = compile("[a-c]b*")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[a-c]b[^/]*?)$")

    assert @files |> fnfilter(matcher) |> sort == ["abc", "abd", "abe", "bb", "cb"] |> sort
  end

  test "[a-y]*[^c]" do
    matcher = compile("[a-y]*[^c]")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[a-y][^/]*?[^c])$")

    assert @files |> fnfilter(matcher) |> sort == ["abd", "abe", "bb", "bcd", "bdir/", "ca", "cb", "dd", "de"] |> sort
  end

  test "a*[^c]" do
    matcher = compile("a*[^c]")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?[^c])$")

    assert @files |> fnfilter(matcher) |> sort == ["abd", "abe"] |> sort
  end

  @files @files ++ ["a-b", "aXb"]

  test "a[X-]b" do
    matcher = compile("a[X-]b")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[X-]b)$")

    assert @files |> fnfilter(matcher) |> sort == ["a-b", "aXb"] |> sort
  end

  @files @files ++ [".x", ".y"]

  test "[^a-c]*" do
    matcher = compile("[^a-c]*")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^a-c][^/]*?)$")

    assert @files |> fnfilter(matcher) |> sort == ["d", "dd", "de"] |> sort
  end

  @files @files ++ ["a*b/", "a*b/ooo"]

  test "a\\*b/*" do
    matcher = compile("a\\*b/*")

    # assert matcher.regex == Regex.compile!("^(?:a\\*b\\/(?!\\.)(?=.)[^/]*?)$")

    assert @files |> fnfilter(matcher) |> sort == ["a*b/ooo"] |> sort
  end

  test "a\\*?/*" do
    matcher = compile("a\\*?/*")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a\\*[^/]\\/(?!\\.)(?=.)[^/]*?)$")

    assert @files |> fnfilter(matcher) |> sort == ["a*b/ooo"] |> sort
  end


  test "*\\\\!*" do
    matcher = compile("*\\\\!*")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/]*?\\\\\\![^/]*?)$")

    assert ["echo !7"] |> fnfilter(matcher) |> sort == []
  end

  test "*\\!*" do
    matcher = compile("*\\!*")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/]*?\\![^/]*?)$")

    assert ["echo !7"] |> fnfilter(matcher) |> sort == ["echo !7"]
  end

  test "*.\\*" do
    matcher = compile("*.\\*")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/]*?\\.\\*)$")

    assert ["r.*"] |> fnfilter(matcher) |> sort == ["r.*"]
  end

  test "a[b]c" do
    matcher = compile("a[b]c")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[b]c)$")

    assert @files |> fnfilter(matcher) |> sort == ["abc"] |> sort
  end

  test "a[\\b]c" do
    matcher = compile("a[\\b]c")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[b]c)$")

    assert @files |> fnfilter(matcher) |> sort == ["abc"] |> sort
  end

  test "a?c" do
    matcher = compile("a?c")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]c)$")

    assert @files |> fnfilter(matcher) |> sort == ["abc"] |> sort
  end

  test "a\\*c" do
    matcher = compile("a\\*c")

    # assert matcher.regex == Regex.compile!("^(?:a\\*c)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == []
  end

  test "empty (literally)" do
    matcher = compile("")

    # assert matcher.regex == false

    assert [""] |> fnfilter(matcher) |> sort == [""] |> sort
  end

end
