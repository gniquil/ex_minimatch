defmodule ExMinimatcher do
  defstruct glob: "",
            pattern: [],
            negate: false,
            options: %{
              dot: false,
              nocase: false,
              match_base: false,
              nonegate: false,
              noext: false,
              noglobstar: false,
              nocomment: false,
              nobrace: false,
              log: nil
            }

  @qmark "[^/]"
  def qmark, do: @qmark

  @globstar :globstar
  def globstar, do: @globstar

  # * => any number of characters
  @star "#{@qmark}*?"
  def star, do: @star

  # characters that need to be escaped in RegExp.
  @re_specials [ "(", ")", ".", "*", "{", "}", "+", "?", "[", "]", "^", "$", "\\", "!" ]
  def re_specials, do: @re_specials

  @slash_split ~r/\/+/
  def slash_split, do: @slash_split
end
