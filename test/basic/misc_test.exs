defmodule MiscTest do
  use ExUnit.Case, async: true

  import ExMinimatch
  import Enum, only: [sort: 1]

  # IO.puts "Test cases for: Paren Sets, Brace Expansion, Comment/Negation, Unclosed, Crazy Nested"

  test "*(a/b)" do
    assert ["a/b"] |> filter("*(a/b)") |> sort == []
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
    assert ["a", "ab", "ac", "ad"] |> filter("*(a|{b),c)}") |> sort == ["a", "ab", "ac"]
  end

  # // test partial parsing in the presence of comment/negation chars
  test "[!a*" do
    assert ["[!ab", "[ab"] |> filter("[!a*") |> sort == ["[!ab"]
  end

  test "[#a*" do
    assert ["[#ab", "[ab"] |> filter("[#a*") |> sort == ["[#ab"]
  end

  # like: {a,b|c\\,d\\\|e} except it's unclosed, so it has to be escaped.
  test "+(a|*\\|c\\\\|d\\\\\\|e\\\\\\\\|f\\\\\\\\\\|g" do
    assert ["+(a|b\\|c\\\\|d\\\\|e\\\\\\\\|f\\\\\\\\|g", "a", "b\\c"]
            |> filter("+(a|*\\|c\\\\|d\\\\\\|e\\\\\\\\|f\\\\\\\\\\|g") |> sort
            ==
            ["+(a|b\\|c\\\\|d\\\\|e\\\\\\\\|f\\\\\\\\|g"]
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
    assert @files |> filter("*(a|{b,c})") |> sort == ["a", "b", "c", "ab", "ac"] |> sort
  end

  test "{a,*(b|c,d)}" do
    assert @files |> filter("{a,*(b|c,d)}") |> sort == ["a", "(b|c", "*(b|c", "d)"] |> sort
  end

  test "{a,*(b|{c,d})}" do
    assert @files |> filter("{a,*(b|{c,d})}") |> sort == ["a","b", "bc", "cb", "c", "d"] |> sort
  end

  test "*(a|{b|c,c})" do
    assert @files |> filter("*(a|{b|c,c})") |> sort == ["a", "b", "c", "ab", "ac", "bc", "cb"] |> sort
  end

  # various flag settings.
  test "*(a|{b|c,c}) with noext: true" do
    assert @files |> filter("*(a|{b|c,c})", %{noext: true}) |> sort == ["x(a|b|c)", "x(a|c)", "(a|b|c)", "(a|c)"] |> sort
  end

  # match base is not implemented correctly in the original minimatchjs
  # here we don't support it, but keep this here for reference
  test "a?b" do
    assert ["x/y/acb", "acb/", "acb/d/e", "x/y/acb/d"] |> filter("a?b", %{match_base: true}) |> sort == ["x/y/acb", "acb/"] |> sort
  end

  test "#*" do
    assert ["#a", "#b", "c#d"] |> filter("#*") |> sort == []
  end

  test "#* with nocomment: true" do
    assert ["#a", "#b", "c#d"] |> filter("#*", %{nocomment: true}) |> sort == ["#a", "#b"] |> sort
  end
end
