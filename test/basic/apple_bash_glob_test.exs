defmodule AppleBashGlobTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3]
  import Enum, only: [filter: 2, sort: 1]

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
    assert @files |> filter(fn file -> match(file, "*/man*/bash.*") end) |> sort == ["man/man1/bash.1"]
  end

  test "man/man1/bash.1" do
    assert @files |> filter(fn file -> match(file, "man/man1/bash.1") end) |> sort == ["man/man1/bash.1"]
  end

  test "a***c" do
    assert ["abc"] |> filter(fn file -> match(file, "a***c") end) |> sort == ["abc"]
  end

  test "a*****?c" do
    assert ["abc"] |> filter(fn file -> match(file, "a*****?c") end) |> sort == ["abc"]
  end

  test "?*****??" do
    assert ["abc"] |> filter(fn file -> match(file, "?*****??") end) |> sort == ["abc"]
  end

  test "*****??" do
    assert ["abc"] |> filter(fn file -> match(file, "*****??") end) |> sort == ["abc"]
  end

  test "?*****?c" do
    assert ["abc"] |> filter(fn file -> match(file, "?*****?c") end) |> sort == ["abc"]
  end

  test "?***?****c" do
    assert ["abc"] |> filter(fn file -> match(file, "?***?****c") end) |> sort == ["abc"]
  end

  test "?***?****?" do
    assert ["abc"] |> filter(fn file -> match(file, "?***?****?") end) |> sort == ["abc"]
  end

  test "?***?****" do
    assert ["abc"] |> filter(fn file -> match(file, "?***?****") end) |> sort == ["abc"]
  end

  test "*******c" do
    assert ["abc"] |> filter(fn file -> match(file, "*******c") end) |> sort == ["abc"]
  end

  test "*******?" do
    assert ["abc"] |> filter(fn file -> match(file, "*******?") end) |> sort == ["abc"]
  end

  test "a*cd**?**??k" do
    assert ["abcdecdhjk"] |> filter(fn file -> match(file, "a*cd**?**??k") end) |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??k" do
    assert ["abcdecdhjk"] |> filter(fn file -> match(file, "a**?**cd**?**??k") end) |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??k***" do
    assert ["abcdecdhjk"] |> filter(fn file -> match(file, "a**?**cd**?**??k***") end) |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??***k" do
    assert ["abcdecdhjk"] |> filter(fn file -> match(file, "a**?**cd**?**??***k") end) |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??***k**" do
    assert ["abcdecdhjk"] |> filter(fn file -> match(file, "a**?**cd**?**??***k**") end) |> sort == ["abcdecdhjk"]
  end

  test "a****c**?**??*****" do
    assert ["abcdecdhjk"] |> filter(fn file -> match(file, "a****c**?**??*****") end) |> sort == ["abcdecdhjk"]
  end

  test "[-abc]" do
    assert ["-"] |> filter(fn file -> match(file, "[-abc]") end) |> sort == ["-"]
  end

  test "[abc-]" do
    assert ["-"] |> filter(fn file -> match(file, "[abc-]") end) |> sort == ["-"]
  end

  test "\\" do
    assert ["\\"] |> filter(fn file -> match(file, "\\") end) |> sort == ["\\"]
  end

  test "[\\\\]" do
    assert ["\\"] |> filter(fn file -> match(file, "[\\\\]") end) |> sort == ["\\"]
  end

  test "[[]" do
    assert ["["] |> filter(fn file -> match(file, "[[]") end) |> sort == ["["]
  end

  test "[" do
    assert ["["] |> filter(fn file -> match(file, "[") end) |> sort == ["["]
  end

  test "[*" do
    assert ["[abc"] |> filter(fn file -> match(file, "[*") end) |> sort == ["[abc"]
  end

  # a right bracket shall lose its special meaning and
  # represent itself in a bracket expression if it occurs
  # first in the list.  -- POSIX.2 2.8.3.2

  test "[]]" do
    assert ["]"] |> filter(fn file -> match(file, "[]]") end) |> sort == ["]"]
  end

  test "[]-]" do
    assert ["]"] |> filter(fn file -> match(file, "[]-]") end) |> sort == ["]"]
  end

  test "[a-\z]" do
    assert ["p"] |> filter(fn file -> match(file, "[a-\z]") end) |> sort ==["p"]
  end

  test "??**********?****?" do
    assert ["abc"] |> filter(fn file -> match(file, "??**********?****?") end) |> sort == []
  end

  test "??**********?****c" do
    assert ["abc"] |> filter(fn file -> match(file, "??**********?****c") end) |> sort == []
  end

  test "?************c****?****" do
    assert ["abc"] |> filter(fn file -> match(file, "?************c****?****") end) |> sort == []
  end

  test "*c*?**" do
    assert ["abc"] |> filter(fn file -> match(file, "*c*?**") end) |> sort == []
  end

  test "a*****c*?**" do
    assert ["abc"] |> filter(fn file -> match(file, "a*****c*?**") end) |> sort == []
  end

  test "a********???*******" do
    assert ["abc"] |> filter(fn file -> match(file, "a********???*******") end) |> sort == []
  end

  test "[]" do
    assert ["a"] |> filter(fn file -> match(file, "[]") end) |> sort == []
  end

  test "[abc" do
    assert ["["] |> filter(fn file -> match(file, "[abc") end) |> sort == []
  end

end
