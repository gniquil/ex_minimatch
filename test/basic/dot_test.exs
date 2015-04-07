defmodule DotTest do
  use ExUnit.Case, async: true

  import ExMinimatch
  import Enum, only: [sort: 1]

  # IO.puts "Test cases for: dots should not match unless requested"

  test "**" do
    assert ["a/b", "a/.d", ".a/.d"] |> filter("**") |> sort == ["a/b"]

    # this also tests that changing the options needs
    # to change the cache key, even if the pattern is
    # the same! (Caching DOESNOT APPLY FOR ExMinimatch as we don't use a cache yet)
    assert [".a/.d", "a/.d", "a/b"] |> filter("**", %{dot: true}) |> sort == ["a/b", "a/.d", ".a/.d"] |> sort
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
    assert @files |> filter("a/*/b", %{dot: true}) |> sort == ["a/c/b", "a/.d/b"] |> sort
  end

  test "a/.*/b with dot: true" do
    assert @files |> filter("a/.*/b", %{dot: true}) |> sort == ["a/./b", "a/../b", "a/.d/b"] |> sort
  end

  test "a/*/b" do
    assert @files |> filter("a/*/b") |> sort == ["a/c/b"] |> sort
  end

  test "a/.*/b" do
    assert @files |> filter("a/.*/b") |> sort == ["a/./b", "a/../b", "a/.d/b"] |> sort
  end
end
