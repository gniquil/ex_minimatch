defmodule NegationTest do
  use ExUnit.Case, async: true

  import ExMinimatch
  import Enum, only: [sort: 1]

  # IO.puts "Test cases for: Negation"

  @files ["d", "e", "!ab", "!abc", "a!b", "\\!a"]

  test "anything that is NOT a* matches" do
    assert @files |> filter("!a*") |> sort == ["\\!a", "d", "e", "!ab", "!abc"] |> sort
  end

  test "anything that IS !a* matches" do
    assert @files |> filter("!a*", %{nonegate: true}) |> sort == ["!ab", "!abc"] |> sort
  end

  test "anything that IS a* matches" do
    assert @files |> filter("!!a*") |> sort == ["a!b"]
  end

  test "anything that is NOT !a* matches" do
    assert @files |> filter("!\\!a*") |> sort == ["a!b", "d", "e", "\\!a"] |> sort
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
    assert @files |> filter("*.!(js)") |> sort == ["foo.bar", "foo.", "boo.js.boo"] |> sort
  end
end
