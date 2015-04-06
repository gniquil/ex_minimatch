defmodule NegationTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3]
  import Enum, only: [filter: 2, sort: 1]

  IO.puts "Test cases for: Negation"

  @files ["d", "e", "!ab", "!abc", "a!b", "\\!a"]

  test "anything that is NOT a* matches" do
    assert @files |> filter(fn file -> match(file, "!a*") end) |> sort == ["\\!a", "d", "e", "!ab", "!abc"] |> sort
  end

  test "anything that IS !a* matches" do
    assert @files |> filter(fn file -> match(file, "!a*", %{nonegate: true}) end) |> sort == ["!ab", "!abc"] |> sort
  end

  test "anything that IS a* matches" do
    assert @files |> filter(fn file -> match(file, "!!a*") end) |> sort == ["a!b"]
  end

  test "anything that is NOT !a* matches" do
    assert @files |> filter(fn file -> match(file, "!\\!a*") end) |> sort == ["a!b", "d", "e", "\\!a"] |> sort
  end

  # negation nestled within a pattern
  @files ["foo.js",
          "foo.bar",
          # can't match this one without negative lookbehind.
          "foo.js.js",
          "blar.js",
          "foo.",
          "boo.js.boo"]

  test "*.!(js)" do
    assert @files |> filter(fn file -> match(file, "*.!(js)") end) |> sort == ["foo.bar", "foo.", "boo.js.boo"] |> sort
  end
end
