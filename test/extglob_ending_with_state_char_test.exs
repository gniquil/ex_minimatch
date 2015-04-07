defmodule ExtglobEndingWithStateCharTest do
  use ExUnit.Case

  import ExMinimatch

  IO.puts "Test cases for: extglob ending with state character"

  test "*/man*/bash.*" do
    assert match("a?(b*)", "ax") == false
    assert match("?(a*|b)", "ax") == true

    # IO.inspect compile("**/")
    # assert filter(["./a/b/c/d.1", "./b/c/d.1", "./c/d.1", "./d.1"], "**/d.1") == ["./a/b/c/d.1", "./b/c/d.1", "./c/d.1", "./d.1"]

    # assert match("**/d.1", "./d.1") == true
  end
end
