defmodule DotTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3, compile: 1, compile: 2, fnmatch: 2, fnfilter: 2]
  import Enum, only: [sort: 1]

  IO.puts "Test cases for: dots should not match unless requested"

  test "**" do
    matcher = compile("**")

    # assert matcher.regex == Regex.compile!("^(?:(?:(?!(?:\\/|^)\\.).)*?)$")

    assert ["a/b", "a/.d", ".a/.d"] |> fnfilter(matcher) |> sort == ["a/b"]

    # this also tests that changing the options needs
    # to change the cache key, even if the pattern is
    # the same! (Caching DOESNOT APPLY FOR ExMinimatch as we don't use a cache yet)
    matcher = compile("**", %{dot: true})

    # assert matcher.regex == Regex.compile!("^(?:(?:(?!(?:\\/|^)(?:\\.{1,2})($|\\/)).)*?)$")

    assert [".a/.d", "a/.d", "a/b"] |> fnfilter(matcher) |> sort == ["a/b", "a/.d", ".a/.d"] |> sort
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
    # assert @files |> filter(fn file -> match(file, "a/*/b", %{dot: true}) end) |> sort == ["a/c/b", "a/.d/b"] |> sort

    matcher = compile("a/*/b", %{dot: true})

    # assert matcher.regex == Regex.compile!("^(?:a\\/(?!(?:^|\\/)\\.{1,2}(?:$|\\/))(?=.)[^/]*?\\/b)$")

    # Note the following is actually what's in minimatch.js, but seems to be a
    # bit weird. Filed issue here:
    # https://github.com/isaacs/minimatch/issues/62
    assert @files |> fnfilter(matcher) |> sort == ["a/c/b", "a/.d/b"] |> sort
  end

  test "a/.*/b with dot: true" do
    matcher = compile("a/.*/b", %{dot: true})

    # assert matcher.regex == Regex.compile!("^(?:a\\/(?=.)\\.[^/]*?\\/b)$")

    assert @files |> fnfilter(matcher) |> sort == ["a/./b", "a/../b", "a/.d/b"] |> sort
  end

  test "a/*/b" do
    matcher = compile("a/*/b")

    # assert matcher.regex == Regex.compile!("^(?:a\\/(?!\\.)(?=.)[^/]*?\\/b)$")

    assert @files |> fnfilter(matcher) |> sort == ["a/c/b"] |> sort
  end

  test "a/.*/b" do
    matcher = compile("a/.*/b")

    # assert matcher.regex == Regex.compile!("^(?:a\\/(?=.)\\.[^/]*?\\/b)$")

    assert @files |> fnfilter(matcher) |> sort == ["a/./b", "a/../b", "a/.d/b"] |> sort
  end
end
