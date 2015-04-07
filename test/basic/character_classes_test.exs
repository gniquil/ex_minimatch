defmodule CharacterClassesTest do
  use ExUnit.Case, async: true

  import ExMinimatch
  import Enum, only: [sort: 1]

  # IO.puts "Test cases for: character classes"

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
    assert @files |> filter("[a-c]b*") |> sort == ["abc", "abd", "abe", "bb", "cb"] |> sort
  end

  test "[a-y]*[^c]" do
    assert @files |> filter("[a-y]*[^c]") |> sort == ["abd", "abe", "bb", "bcd", "bdir/", "ca", "cb", "dd", "de"] |> sort
  end

  test "a*[^c]" do
    assert @files |> filter("a*[^c]") |> sort == ["abd", "abe"] |> sort
  end

  @files @files ++ ["a-b", "aXb"]

  test "a[X-]b" do
    assert @files |> filter("a[X-]b") |> sort == ["a-b", "aXb"] |> sort
  end

  @files @files ++ [".x", ".y"]

  test "[^a-c]*" do
    assert @files |> filter("[^a-c]*") |> sort == ["d", "dd", "de"] |> sort
  end

  @files @files ++ ["a*b/", "a*b/ooo"]

  test "a\\*b/*" do
    assert @files |> filter("a\\*b/*") |> sort == ["a*b/ooo"] |> sort
  end

  test "a\\*?/*" do
    assert @files |> filter("a\\*?/*") |> sort == ["a*b/ooo"] |> sort
  end


  test "*\\\\!*" do
    assert ["echo !7"] |> filter("*\\\\!*") |> sort == []
  end

  test "*\\!*" do
    assert ["echo !7"] |> filter("*\\!*") |> sort == ["echo !7"]
  end

  test "*.\\*" do
    assert ["r.*"] |> filter("*.\\*") |> sort == ["r.*"]
  end

  test "a[b]c" do
    assert @files |> filter("a[b]c") |> sort == ["abc"] |> sort
  end

  test "a[\\b]c" do
    assert @files |> filter("a[\\b]c") |> sort == ["abc"] |> sort
  end

  test "a?c" do
    assert @files |> filter("a?c") |> sort == ["abc"] |> sort
  end

  test "a\\*c" do
    assert ["abc"] |> filter("a\\*c") |> sort == []
  end

  test "empty (literally)" do
    assert [""] |> filter("") |> sort == [""] |> sort
  end

end
