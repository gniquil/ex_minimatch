defmodule NegationTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3, compile: 1, compile: 2, fnmatch: 2, fnfilter: 2]
  import Enum, only: [sort: 1]

  IO.puts "Test cases for: Negation"

  @files ["d", "e", "!ab", "!abc", "a!b", "\\!a"]

  test "anything that is NOT a* matches" do
    matcher = compile("!a*")

    # assert matcher.regex == Regex.compile!("^(?!^(?:(?=.)a[^/]*?)$).*$")

    assert @files |> fnfilter(matcher) |> sort == ["\\!a", "d", "e", "!ab", "!abc"] |> sort
  end

  test "anything that IS !a* matches" do
    matcher = compile("!a*", %{nonegate: true})

    # assert matcher.regex == Regex.compile!("^(?:(?=.)\\!a[^/]*?)$")

    assert @files |> fnfilter(matcher) |> sort == ["!ab", "!abc"] |> sort
  end

  test "anything that IS a* matches" do
    matcher = compile("!!a*")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]*?)$")

    assert @files |> fnfilter(matcher) |> sort == ["a!b"]
  end

  test "anything that is NOT !a* matches" do
    matcher = compile("!\\!a*")

    # assert matcher.regex == Regex.compile!("^(?!^(?:(?=.)\\!a[^/]*?)$).*$")

    assert @files |> fnfilter(matcher) |> sort == ["a!b", "d", "e", "\\!a"] |> sort
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
    matcher = compile("*.!(js)")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/]*?\\.(?:(?!js)[^/]*?))$")

    assert @files |> fnfilter(matcher) |> sort == ["foo.bar", "foo.", "boo.js.boo"] |> sort
  end
end
