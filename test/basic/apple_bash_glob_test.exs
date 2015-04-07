defmodule AppleBashGlobTest do
  use ExUnit.Case, async: true

  import ExMinimatch
  import Enum, only: [sort: 1]

  # IO.puts "Test cases for: http://www.opensource.apple.com/source/bash/bash-23/bash/tests/glob-test"

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
    assert @files |> filter("*/man*/bash.*") |> sort == ["man/man1/bash.1"] |> sort
  end

  test "man/man1/bash.1" do
    assert @files |> filter("man/man1/bash.1") |> sort == ["man/man1/bash.1"]
  end

  test "a***c" do
    assert ["abc"] |> filter("a***c") |> sort == ["abc"]
  end

  test "a*****?c" do
    assert ["abc"] |> filter("a*****?c") |> sort == ["abc"]
  end

  test "?*****??" do
    assert ["abc"] |> filter("?*****??") |> sort == ["abc"]
  end

  test "*****??" do
    assert ["abc"] |> filter("*****??") |> sort == ["abc"]
  end

  test "?*****?c" do
    assert ["abc"] |> filter("?*****?c") |> sort == ["abc"]
  end

  test "?***?****c" do
    assert ["abc"] |> filter("?***?****c") |> sort == ["abc"]
  end

  test "?***?****?" do
    assert ["abc"] |> filter("?***?****?") |> sort == ["abc"]
  end

  test "?***?****" do
    assert ["abc"] |> filter("?***?****") |> sort == ["abc"]
  end

  test "*******c" do
    assert ["abc"] |> filter("*******c") |> sort == ["abc"]
  end

  test "*******?" do
    assert ["abc"] |> filter("*******?") |> sort == ["abc"]
  end

  test "a*cd**?**??k" do
    assert ["abcdecdhjk"] |> filter("a*cd**?**??k") |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??k" do
    assert ["abcdecdhjk"] |> filter("a**?**cd**?**??k") |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??k***" do
    assert ["abcdecdhjk"] |> filter("a**?**cd**?**??k***") |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??***k" do
    assert ["abcdecdhjk"] |> filter("a**?**cd**?**??***k") |> sort == ["abcdecdhjk"]
  end

  test "a**?**cd**?**??***k**" do
    assert ["abcdecdhjk"] |> filter("a**?**cd**?**??***k**") |> sort == ["abcdecdhjk"]
  end

  test "a****c**?**??*****" do
    assert ["abcdecdhjk"] |> filter("a****c**?**??*****") |> sort == ["abcdecdhjk"]
  end

  test "[-abc]" do
    assert ["-"] |> filter("[-abc]") |> sort == ["-"]
  end

  test "[abc-]" do
    assert ["-"] |> filter("[abc-]") |> sort == ["-"]
  end

  test "\\" do
    assert ["\\"] |> filter("\\") |> sort == ["\\"]
  end

  test "[\\\\]" do
    assert ["\\"] |> filter("[\\\\]") |> sort == ["\\"]
  end

  test "[[]" do
    assert ["["] |> filter("[[]") == ["["]
  end

  test "[" do
    assert ["["] |> filter("[") == ["["]
  end

  test "[*" do
    assert ["[abc"] |> filter("[*") == ["[abc"]
  end

  # # a right bracket shall lose its special meaning and
  # # represent itself in a bracket expression if it occurs
  # # first in the list.  -- POSIX.2 2.8.3.2

  test "[]]" do
    assert ["]"] |> filter("[]]") |> sort == ["]"]
  end

  test "[]-]" do
    assert ["]"] |> filter("[]-]") |> sort == ["]"]
  end

  test "[a-\z]" do
    assert ["p"] |> filter("[a-\z]") |> sort ==["p"]
  end

  test "??**********?****?" do
    assert ["abc"] |> filter("??**********?****?") |> sort == []
  end

  test "??**********?****c" do
    assert ["abc"] |> filter("??**********?****c") |> sort == []
  end

  test "?************c****?****" do
    assert ["abc"] |> filter("?************c****?****") |> sort == []
  end

  test "*c*?**" do
    assert ["abc"] |> filter("*c*?**") |> sort == []
  end

  test "a*****c*?**" do
    assert ["abc"] |> filter("a*****c*?**") |> sort == []
  end

  test "a********???*******" do
    assert ["abc"] |> filter("a********???*******") |> sort == []
  end

  test "[]" do
    assert ["a"] |> filter("[]") |> sort == []
  end

  test "[abc" do
    assert ["["] |> filter("[abc") |> sort == []
  end

end
