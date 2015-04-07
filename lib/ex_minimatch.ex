defmodule ExMinimatch do
  import ExMinimatch.Compiler
  import ExMinimatch.Matcher

  @doc """
  return compiles a %ExMinimatcher{} struct, which can be used to match files

  This function saves compilation time if the same glob pattern will be used to
  repeatedly match files.
  """
  def compile(glob), do: compile(glob, %{})
  def compile(glob, options) do
    options = %{
      dot: false,
      nocase: false,
      match_base: false,
      nonegate: false,
      noext: false,
      noglobstar: false,
      nocomment: false,
      nobrace: false,
      log: nil
    } |> Dict.merge(options)

    compile_matcher(glob, options)
  end

  def fnmatch(%ExMinimatcher{pattern: pattern}, file) when pattern == [] and file == "", do: true
  def fnmatch(%ExMinimatcher{pattern: pattern}, _file) when pattern == [], do: false
  def fnmatch(matcher, file), do: match_file(file, matcher)

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
