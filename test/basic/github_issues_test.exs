defmodule GithubIssuesTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3]
  import Enum, only: [filter: 2, sort: 1]

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
    assert @files |> filter(fn file -> match(file, "**/.x/**") end) |> sort == [".x/",
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
    assert @files |> filter(fn file -> match(file, "[z-a]") end) |> sort == []
  end

  test "a/[2015-03-10T00:23:08.647Z]/z" do
    assert @files |> filter(fn file -> match(file, "a/[2015-03-10T00:23:08.647Z]/z") end) |> sort == []
  end

  test "[a-0][a-\u0100]" do
    assert @files |> filter(fn file -> match(file, "[a-0][a-\u0100]") end) |> sort == []
  end
end
