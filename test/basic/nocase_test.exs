defmodule NocaseTest do
  use ExUnit.Case

  import ExMinimatch, only: [match: 2, match: 3]
  import Enum, only: [filter: 2, sort: 1]

  IO.puts "Test cases for: nocase"

  test "XYZ" do
    assert ["xYz", "ABC", "IjK"] |> filter(fn file -> match(file, "XYZ", %{nocase: true}) end) |> sort == ["xYz"]
  end

  test "ab*" do
    assert ["xYz", "ABC", "IjK"] |> filter(fn file -> match(file, "ab*", %{nocase: true}) end) |> sort == ["ABC"]
  end

  test "[ia]?[ck]" do
    assert ["xYz", "ABC", "IjK"] |> filter(fn file -> match(file, "[ia]?[ck]", %{nocase: true}) end) |> sort == ["ABC", "IjK"]
  end
end
