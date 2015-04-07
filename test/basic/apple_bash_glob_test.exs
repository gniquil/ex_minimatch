defmodule AppleBashGlobTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3, compile: 1, fnmatch: 2, fnfilter: 2]
  import Enum, only: [sort: 1]

  IO.puts "Test cases for: http://www.opensource.apple.com/source/bash/bash-23/bash/tests/glob-test"

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
    "bdir/cfile",
    "a-b",
    "aXb",
    ".x",
    ".y",
    "a*b/",
    "a*b/ooo",
    "man/",
    "man/man1/",
    "man/man1/bash.1"
  ]

  test "*/man*/bash.*" do
    matcher = compile("*/man*/bash.*")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/]*?\\/(?=.)man[^/]*?\\/(?=.)bash\\.[^/]*?)$")

    assert @files |> fnfilter(matcher) |> sort == ["man/man1/bash.1"] |> sort
  end

  test "man/man1/bash.1" do
    matcher = compile("man/man1/bash.1")

    # assert matcher.regex == Regex.compile!("^(?:man\\/man1\\/bash\\.1)$")

    assert @files |> fnfilter(matcher) |> sort == ["man/man1/bash.1"]
  end

  test "a***c" do
    matcher = compile("a***c")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?[^/]*?[^/]*?c)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == ["abc"]
  end

  test "a*****?c" do
    matcher = compile("a*****?c")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]c)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == ["abc"]
  end

  test "?*****??" do
    matcher = compile("?*****??")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/])$")

    assert ["abc"] |> fnfilter(matcher) |> sort == ["abc"]
  end

  test "*****??" do
    matcher = compile("*****??")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/])$")

    assert ["abc"] |> fnfilter(matcher) |> sort == ["abc"]
  end

  test "?*****?c" do
    matcher = compile("?*****?c")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]c)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == ["abc"]
  end

  test "?***?****c" do
    matcher = compile("?***?****c")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?c)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == ["abc"]
  end

  test "?***?****?" do
    matcher = compile("?***?****?")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?[^/])$")

    assert ["abc"] |> fnfilter(matcher) |> sort == ["abc"]
  end

  test "?***?****" do
    matcher = compile("?***?****")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == ["abc"]
  end

  test "*******c" do
    matcher = compile("*******c")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?c)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == ["abc"]
  end

  test "*******?" do
    matcher = compile("*******?")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/])$")

    assert ["abc"] |> fnfilter(matcher) |> sort == ["abc"]
  end

  test "a*cd**?**??k" do
    matcher = compile("a*cd**?**??k")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?cd[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/]k)$")

    assert ["abcdecdhjk"] |> fnfilter(matcher) |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??k" do
    matcher = compile("a**?**cd**?**??k")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?[^/]*?[^/][^/]*?[^/]*?cd[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/]k)$")

    assert ["abcdecdhjk"] |> fnfilter(matcher) |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??k***" do
    matcher = compile("a**?**cd**?**??k***")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?[^/]*?[^/][^/]*?[^/]*?cd[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/]k[^/]*?[^/]*?[^/]*?)$")

    assert ["abcdecdhjk"] |> fnfilter(matcher) |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??***k" do
    matcher = compile("a**?**cd**?**??***k")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?[^/]*?[^/][^/]*?[^/]*?cd[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/][^/]*?[^/]*?[^/]*?k)$")

    assert ["abcdecdhjk"] |> fnfilter(matcher) |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??***k**" do
    matcher = compile("a**?**cd**?**??***k**")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?[^/]*?[^/][^/]*?[^/]*?cd[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/][^/]*?[^/]*?[^/]*?k[^/]*?[^/]*?)$")

    assert ["abcdecdhjk"] |> fnfilter(matcher) |> sort == ["abcdecdhjk"]
  end

  test "a****c**?**??*****" do
    matcher = compile("a****c**?**??*****")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?[^/]*?[^/]*?[^/]*?c[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?)$")

    assert ["abcdecdhjk"] |> fnfilter(matcher) |> sort == ["abcdecdhjk"]
  end

  test "[-abc]" do
    matcher = compile("[-abc]")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[-abc])$")

    assert ["-"] |> fnfilter(matcher) |> sort == ["-"]
  end

  test "[abc-]" do
    matcher = compile("[abc-]")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[abc-])$")

    assert ["-"] |> fnfilter(matcher) |> sort == ["-"]
  end

  test "\\" do
    matcher = compile("\\")

    # assert matcher.regex == Regex.compile!("^(?:\\\\)$")

    assert ["\\"] |> fnfilter(matcher) |> sort == ["\\"]
  end

  test "[\\\\]" do
    matcher = compile("[\\\\]")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[\\\\])$")

    assert ["\\"] |> fnfilter(matcher) |> sort == ["\\"]
  end

  test "[[]" do
    matcher = compile("[[]")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[\\[])$")

    assert ["["] |> fnfilter(matcher) == ["["]
  end

  test "[" do
    matcher = compile("[")

    # assert matcher.regex == Regex.compile!("^(?:\\[)$")

    assert ["["] |> fnfilter(matcher) == ["["]
  end

  test "[*" do
    matcher = compile("[*")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)\\[(?!\\.)(?=.)[^/]*?)$")

    assert ["[abc"] |> fnfilter(matcher) == ["[abc"]
  end

  # # a right bracket shall lose its special meaning and
  # # represent itself in a bracket expression if it occurs
  # # first in the list.  -- POSIX.2 2.8.3.2

  test "[]]" do
    matcher = compile("[]]")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[\\]])$")

    assert ["]"] |> fnfilter(matcher) |> sort == ["]"]
  end

  test "[]-]" do
    matcher = compile("[]-]")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[\\]-])$")

    assert ["]"] |> fnfilter(matcher) |> sort == ["]"]
  end

  test "[a-\z]" do
    matcher = compile("[a-\z]")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[a-z])$")

    assert ["p"] |> fnfilter(matcher) |> sort ==["p"]
  end

  test "??**********?****?" do
    matcher = compile("??**********?****?")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/][^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?[^/])$")

    assert ["abc"] |> fnfilter(matcher) |> sort == []
  end

  test "??**********?****c" do
    matcher = compile("??**********?****c")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/][^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?c)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == []
  end

  test "?************c****?****" do
    matcher = compile("?************c****?****")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?c[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == []
  end

  test "*c*?**" do
    matcher = compile("*c*?**")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/]*?c[^/]*?[^/][^/]*?[^/]*?)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == []
  end

  test "a*****c*?**" do
    matcher = compile("a*****c*?**")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?c[^/]*?[^/][^/]*?[^/]*?)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == []
  end

  test "a********???*******" do
    matcher = compile("a********???*******")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/][^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?)$")

    assert ["abc"] |> fnfilter(matcher) |> sort == []
  end

  test "[]" do
    matcher = compile("[]")

    # assert matcher.regex == Regex.compile!("^(?:\\[\\])$")

    assert ["a"] |> fnfilter(matcher) |> sort == []
  end

  test "[abc" do
    matcher = compile("[abc")

    # assert matcher.regex == Regex.compile!("^(?:\\[abc)$")

    assert ["["] |> fnfilter(matcher) |> sort == []
  end

end
