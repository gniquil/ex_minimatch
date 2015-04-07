defmodule ExMinimatch do
  import ExMinimatch.Compiler

  def compile(glob), do: compile(glob, %{})
  def compile(glob, options) do
    options = %{
      dot: false,
      nocase: false,
      match_base: false, #this is not supported as the regexp version does NOT support this, and the non-regex version has too many inconsistencies with the regex version.
      nonegate: false,
      noext: false,
      noglobstar: false,
      nocomment: false,
      nobrace: false,
      log: nil
    } |> Dict.merge(options)

    compile_matcher(glob, options)
  end

  def fnmatch(%{regex_parts_set: regex_parts_set}, "") when regex_parts_set == [], do: true
  def fnmatch(%{regex_parts_set: regex_parts_set}, _file) when not regex_parts_set, do: false
  # def fnmatch(%{regex: regex}, file), do: Regex.match?(regex, file)
  def fnmatch(%{regex_parts_set: regex_parts_set, negate: negate, options: options}, file) do
    match_file(file, regex_parts_set, negate, options)
  end

  @doc """
  return true if the file matches the pattern

  ## Examples

      iex> match("**/*.png", "qwer.png")
      true

      iex> match("**/*.png", "qwer/qwer.png")
      true

  """
  def match(pattern, file, options \\ %{}) do
    pattern
    |> compile(options)
    |> fnmatch(file)
  end

  # for file collections
  def fnfilter(files, matcher) do
    files
    |> Enum.filter(&fnmatch(matcher, &1))
  end


  @doc """
  return a list of files that match the given pattern

  ## Examples

      iex> filter(["qwer.png", "asdf/qwer.png"], "**/*.png")
      ["qwer.png", "asdf/qwer.png"]

      iex> filter(["qwer/pic1a.png", "qwer/asdf/pic2a.png", "asdf/pic2c.jpg"], "**/*{1..2}{a,b}.{png,jpg}")
      ["qwer/pic1a.png", "qwer/asdf/pic2a.png"]

  """
  def filter(files, pattern), do: filter(files, pattern, %{})
  def filter(files, pattern, options) do
    matcher = pattern |> compile(options)

    files |> fnfilter(matcher)
  end
end
