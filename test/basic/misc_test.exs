defmodule MiscTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3, compile: 1, compile: 2, fnmatch: 2, fnfilter: 2]
  import Enum, only: [sort: 1]

  IO.puts "Test cases for: Paren Sets, Brace Expansion, Comment/Negation, Unclosed, Crazy Nested"

  test "*(a/b)" do
    matcher = compile("*(a/b)")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/]*?\\(a\\/b\\))$")

    assert ["a/b"] |> fnfilter(matcher) |> sort == []
  end

  # brace sets trump all else.
  #
  # invalid glob pattern.  fails on bash4 and bsdglob.
  # however, in this implementation, it's easier just
  # to do the intuitive thing, and let brace-expansion
  # actually come before parsing any extglob patterns,
  # like the documentation seems to say.
  #
  # XXX: if anyone complains about this, either fix it
  # or tell them to grow up and stop complaining.
  #
  # bash/bsdglob says this:
  # , ["*(a|{b),c)}", ["*(a|{b),c)}"], {}, ["a", "ab", "ac", "ad"]]
  # but we do this instead:
  test "*(a|{b),c)}" do
    matcher = compile("*(a|{b),c)}")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)(?:a|b)*|(?!\\.)(?=.)(?:a|c)*)$")

    assert ["a", "ab", "ac", "ad"] |> fnfilter(matcher) |> sort == ["a", "ab", "ac"]
  end

  # // test partial parsing in the presence of comment/negation chars
  test "[!a*" do
    matcher = compile("[!a*")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)\\[(?=.)\\!a[^/]*?)$")

    assert ["[!ab", "[ab"] |> fnfilter(matcher) |> sort == ["[!ab"]
  end

  test "[#a*" do
    matcher = compile("[#a*")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)\\[(?=.)#a[^/]*?)$")

    assert ["[#ab", "[ab"] |> fnfilter(matcher) |> sort == ["[#ab"]
  end

  # like: {a,b|c\\,d\\\|e} except it's unclosed, so it has to be escaped.
  test "+(a|*\\|c\\\\|d\\\\\\|e\\\\\\\\|f\\\\\\\\\\|g" do
    matcher = compile("+(a|*\\|c\\\\|d\\\\\\|e\\\\\\\\|f\\\\\\\\\\|g")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)\\+\\(a\\|[^/]*?\\|c\\\\\\\\\\|d\\\\\\\\\\|e\\\\\\\\\\\\\\\\\\|f\\\\\\\\\\\\\\\\\\|g)$")

    assert ["+(a|b\\|c\\\\|d\\\\|e\\\\\\\\|f\\\\\\\\|g", "a", "b\\c"] |> fnfilter(matcher) |> sort == ["+(a|b\\|c\\\\|d\\\\|e\\\\\\\\|f\\\\\\\\|g"]
  end

  @files [
          "a", "b", "c", "d",
          "ab",
          "ac",
          "ad",
          "bc", "cb",
          "bc,d", "c,db", "c,d",
          "d)", "(b|c", "*(b|c",
          "b|c", "b|cc", "cb|c",
          "x(a|b|c)", "x(a|c)",
          "(a|b|c)", "(a|c)"
          ]

  test "*(a|{b,c})" do
    matcher = compile("*(a|{b,c})")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)(?:a|b)*|(?!\\.)(?=.)(?:a|c)*)$")

    assert @files |> fnfilter(matcher) |> sort == ["a", "b", "c", "ab", "ac"] |> sort
  end

  test "{a,*(b|c,d)}" do
    matcher = compile("{a,*(b|c,d)}")

    # assert matcher.regex == Regex.compile!("^(?:a|(?!\\.)(?=.)[^/]*?\\(b\\|c|d\\))$")

    assert @files |> fnfilter(matcher) |> sort == ["a", "(b|c", "*(b|c", "d)"] |> sort
  end

  test "{a,*(b|{c,d})}" do
    matcher = compile("{a,*(b|{c,d})}")

    # assert matcher.regex == Regex.compile!("^(?:a|(?!\\.)(?=.)(?:b|c)*|(?!\\.)(?=.)(?:b|d)*)$")

    assert @files |> fnfilter(matcher) |> sort == ["a","b", "bc", "cb", "c", "d"] |> sort
  end

  test "*(a|{b|c,c})" do
    matcher = compile("*(a|{b|c,c})")

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)(?:a|b|c)*|(?!\\.)(?=.)(?:a|c)*)$")

    assert @files |> fnfilter(matcher) |> sort == ["a", "b", "c", "ab", "ac", "bc", "cb"] |> sort
  end

  # various flag settings.
  test "*(a|{b|c,c}) with noext: true" do
    matcher = compile("*(a|{b|c,c})", %{noext: true})

    # assert matcher.regex == Regex.compile!("^(?:(?!\\.)(?=.)[^/]*?\\(a\\|b\\|c\\)|(?!\\.)(?=.)[^/]*?\\(a\\|c\\))$")

    assert @files |> fnfilter(matcher) |> sort == ["x(a|b|c)", "x(a|c)", "(a|b|c)", "(a|c)"] |> sort
  end

  # match base is not implemented correctly in the original minimatchjs
  # here we don't support it, but keep this here for reference
  test "a?b" do
    matcher = compile("a?b", %{match_base: true})

    # assert matcher.regex == Regex.compile!("^(?:(?=.)a[^/]b)$")

    assert ["x/y/acb", "acb/", "acb/d/e", "x/y/acb/d"] |> fnfilter(matcher) |> sort == ["x/y/acb", "acb/"] |> sort
  end

  test "#*" do
    matcher = compile("#*")

    # assert matcher.regex == false

    assert ["#a", "#b", "c#d"] |> fnfilter(matcher) |> sort == []
  end

  test "#* with nocomment: true" do
    matcher = compile("#*", %{nocomment: true})

    # assert matcher.regex == Regex.compile!("^(?:(?=.)#[^/]*?)$")

    assert ["#a", "#b", "c#d"] |> fnfilter(matcher) |> sort == ["#a", "#b"] |> sort
  end
end
