defmodule ExMinimatch.Helper do
  import Dict, only: [merge: 2]

  def debug(obj, options) do
    if options[:log] in [:debug], do: IO.inspect(obj)
  end

  def info(obj, options) do
    if options[:log] in [:info, :debug], do: IO.inspect(obj)
  end

  # preserves the state
  def tap(state, sideback) do
    sideback.(state)

    state
  end

  def transform(state, callback) do
    callback.(state)
  end

  def len(a) when is_binary(a), do: String.length(a)
  def len(a), do: length(a)

  def at(a, i) when is_binary(a), do: String.at(a, i)
  def at(a, i), do: Enum.at(a, i)

  def slice(a, rng) when is_binary(a), do: String.slice(a, rng)
  def slice(a, rng), do: Enum.slice(a, rng)

  def slice(a, i, l) when is_binary(a), do: String.slice(a, i, l)
  def slice(a, i, l), do: Enum.slice(a, i, l)

  # minimatch.js supports 2 types of matching, one's regex based, one is below
  # here we don't support the 2nd type as there are too many inconsistencies
  # between the versions.


end
