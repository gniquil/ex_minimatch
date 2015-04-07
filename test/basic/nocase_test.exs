defmodule NocaseTest do
  use ExUnit.Case, async: true

  import ExMinimatch
  import Enum, only: [sort: 1]

  # IO.puts "Test cases for: nocase"

  test "XYZ" do
    assert ["xYz", "ABC", "IjK"] |> filter("XYZ", %{nocase: true}) |> sort == ["xYz"]
  end

  test "ab*" do
    assert ["xYz", "ABC", "IjK"] |> filter("ab*", %{nocase: true}) |> sort == ["ABC"]
  end

  test "[ia]?[ck]" do
    assert ["xYz", "ABC", "IjK"] |> filter("[ia]?[ck]", %{nocase: true}) |> sort == ["ABC", "IjK"]
  end
end
