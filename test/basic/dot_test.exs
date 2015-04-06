defmodule DotTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3]
  import Enum, only: [filter: 2, sort: 1]

  IO.puts "Test cases for: dots should not match unless requested"

  test "**" do
    assert ["a/b", "a/.d", ".a/.d"] |> filter(fn file -> match(file, "**") end) |> sort == ["a/b"]

    # this also tests that changing the options needs
    # to change the cache key, even if the pattern is
    # the same! (Caching DOESNOT APPLY FOR ExMinimatch as we don't use a cache yet)
    assert [".a/.d", "a/.d", "a/b"] |> filter(fn file -> match(file, "**", %{dot: true}) end) |> sort == ["a/b", "a/.d", ".a/.d"] |> sort
  end

  # .. and . can only match patterns starting with .,
  # even when options.dot is set.

  @files [
    "a/./b",
    "a/../b",
    "a/c/b",
    "a/.d/b"
  ]

  test "a/*/b with dot: true" do
    assert @files |> filter(fn file -> match(file, "a/*/b", %{dot: true}) end) |> sort == ["a/c/b", "a/.d/b"] |> sort
  end

  test "a/.*/b with dot: true" do
    assert @files |> filter(fn file -> match(file, "a/.*/b", %{dot: true}) end) |> sort == ["a/./b", "a/../b", "a/.d/b"] |> sort
  end

  test "a/*/b" do
    assert @files |> filter(fn file -> match(file, "a/*/b") end) |> sort == ["a/c/b"] |> sort
  end

  test "a/.*/b" do
    assert @files |> filter(fn file -> match(file, "a/.*/b") end) |> sort == ["a/./b", "a/../b", "a/.d/b"] |> sort
  end
end
