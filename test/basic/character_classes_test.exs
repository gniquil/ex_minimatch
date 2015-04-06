defmodule CharacterClassesTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3]
  import Enum, only: [filter: 2, sort: 1]

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

  test "/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\\1/" do
    assert @files |> filter(fn file -> match(file, "/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\\1/") end) |> sort == []
  end

  test "/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\1/" do
    assert @files |> filter(fn file -> match(file, "/^root:/{s/^[^:]*:[^:]*:\([^:]*\).*$/\1/") end) |> sort == []
  end

  test "[a-c]b*" do
    assert @files |> filter(fn file -> match(file, "[a-c]b*") end) |> sort == ["abc", "abd", "abe", "bb", "cb"] |> sort
  end

  test "[a-y]*[^c]" do
    assert @files |> filter(fn file -> match(file, "[a-y]*[^c]") end) |> sort == ["abd", "abe", "bb", "bcd", "bdir/", "ca", "cb", "dd", "de"] |> sort
  end

  test "a*[^c]" do
    assert @files |> filter(fn file -> match(file, "a*[^c]") end) |> sort == ["abd", "abe"] |> sort
  end

  @files @files ++ ["a-b", "aXb"]

  test "a[X-]b" do
    assert @files |> filter(fn file -> match(file, "a[X-]b") end) |> sort == ["a-b", "aXb"] |> sort
  end

  @files @files ++ [".x", ".y"]

  test "[^a-c]*" do
    assert @files |> filter(fn file -> match(file, "[^a-c]*") end) |> sort == ["d", "dd", "de"] |> sort
  end

  @files @files ++ ["a*b/", "a*b/ooo"]

  test "a\\*b/*" do
    assert @files |> filter(fn file -> match(file, "a\\*b/*") end) |> sort == ["a*b/ooo"] |> sort
  end

  test "a\\*?/*" do
    assert @files |> filter(fn file -> match(file, "a\\*?/*") end) |> sort == ["a*b/ooo"] |> sort
  end

  test "*\\\\!*" do
    assert ["echo !7"] |> filter(fn file -> match(file, "*\\\\!*") end) |> sort == []
  end

  test "*\\!*" do
    assert ["echo !7"] |> filter(fn file -> match(file, "*\\!*") end) |> sort == ["echo !7"]
  end

  test "*.\\*" do
    assert ["r.*"] |> filter(fn file -> match(file, "*.\\*") end) |> sort == ["r.*"]
  end

  test "a[b]c" do
    assert @files |> filter(fn file -> match(file, "a[b]c") end) |> sort == ["abc"] |> sort
  end

  test "a[\\b]c" do
    assert @files |> filter(fn file -> match(file, "a[\\b]c") end) |> sort == ["abc"] |> sort
  end

  test "a?c" do
    assert @files |> filter(fn file -> match(file, "a?c") end) |> sort == ["abc"] |> sort
  end

  test "a\\*c" do
    assert ["abc"] |> filter(fn file -> match(file, "a\\*c") end) |> sort == []
  end

  test "empty (literally)" do
    assert [""] |> filter(fn file -> match(file, "") end) |> sort == [""] |> sort
  end

end
