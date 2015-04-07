defmodule GithubIssuesTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3, compile: 1, compile: 2, fnmatch: 2, fnfilter: 2]
  import Enum, only: [sort: 1]

  IO.puts "Test cases for: https://github.com/isaacs/minimatch/issues/5"

  @files ["a/b/.x/c",
          "a/b/.x/c/d",
          "a/b/.x/c/d/e",
          "a/b/.x",
          "a/b/.x/",
          "a/.x/b",
          ".x",
          ".x/",
          ".x/a",
          ".x/a/b",
          "a/.x/b/.x/c",
          ".x/.x"]

  test "**/.x/**" do
    matcher = compile("**/.x/**")

    # assert matcher.regex == Regex.compile!("^(?:(?:(?!(?:\\/|^)\\.).)*?\\/\\.x\\/(?:(?!(?:\\/|^)\\.).)*?)$")

    # note that .x/, .x/a, .x/a/b are all included in the original minimatch.js
    # which doesn't look right
    # added comments to https://github.com/isaacs/minimatch/issues/5
    assert @files |> fnfilter(matcher) |> sort == [".x/",
                                                   ".x/a",
                                                   ".x/a/b",
                                                   "a/.x/b",
                                                   "a/b/.x/",
                                                   "a/b/.x/c",
                                                   "a/b/.x/c/d",
                                                   "a/b/.x/c/d/e"] |> sort
  end


  IO.puts "Test cases for: https://github.com/isaacs/minimatch/issues/59"

  test "[z-a]" do
    matcher = compile("[z-a]")

    # assert matcher.regex == Regex.compile!("^(?:\\[z\\-a\\])$")

    assert @files |> fnfilter(matcher) |> sort == []
  end

  test "a/[2015-03-10T00:23:08.647Z]/z" do
    matcher = compile("a/[2015-03-10T00:23:08.647Z]/z")

    # assert matcher.regex == Regex.compile!("^(?:a\\/\\[2015\\-03\\-10T00:23:08\\.647Z\\]\\/z)$")

    assert @files |> fnfilter(matcher) |> sort == []
  end

  test "[a-0][a-\u0100]" do
    matcher = compile("[a-0][a-\x{0100}]")

    # assert matcher.regex == Regex.compile!("^(?:(?=.)\\[a-0\\][a-Ā])$")

    assert @files |> fnfilter(matcher) |> sort == []
  end
end
