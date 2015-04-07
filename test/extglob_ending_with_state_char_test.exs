defmodule ExtglobEndingWithStateCharTest do
  use ExUnit.Case, async: true

  import ExMinimatch

  # IO.puts "Test cases for: extglob ending with state character"

  test "*/man*/bash.*" do
    assert match("a?(b*)", "ax") == false
    assert match("?(a*|b)", "ax") == true
  end
end
