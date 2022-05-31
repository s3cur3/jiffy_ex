defmodule JiffyEx.Opts do
  @moduledoc """
  A converter that converts between the standard Elixir Keyword List options that are typically passed to functions
  and the options that are passed to Erlang's jiffy library.
  """

  @valid_decode_opts [
    :return_trailer,
    :dedupe_keys,
    :copy_strings,
    :null_term,
    :bytes_per_iter,
    :bytes_per_red
  ]
  @valid_encode_opts [
    :uescape,
    :pretty,
    :force_utf8,
    :escape_forward_slashes,
    :bytes_per_iter,
    :bytes_per_red
  ]

  @typep jiffy_opt :: atom | {atom, non_neg_integer | any}
  @typep jiffy_opts :: [jiffy_opt]

  @doc """
  Parses options for the `encode/2` function from a provided Elixir Keyword list into
  a compatible list of options for jiffy.

  This strips out any options that are not valid for jiffy's `encode/2` function
  and then creates a list of atoms and tuples for jiffy to use.
  """
  @spec parse_encode_opts(Keyword.t()) :: jiffy_opts
  def parse_encode_opts(opts) do
    [:use_nil | parse(opts, @valid_encode_opts)]
  end

  @doc """
  Parses options for the `decode/2` function from a provided Elixir Keyword list into
  a compatible list of options for jiffy.

  This strips out any options that are not valid for jiffy's `decode/2` function
  and then creates a list of atoms and tuples for jiffy to use.
  """
  @spec parse_decode_opts(Keyword.t()) :: jiffy_opts
  def parse_decode_opts(opts) do
    [:return_maps, :use_nil | parse(opts, @valid_decode_opts)]
  end

  @spec parse(Keyword.t(), [atom]) :: jiffy_opts
  defp parse(opts, valid_opts) do
    opts
    |> Enum.filter(fn {opt, val} -> Enum.member?(valid_opts, opt) and val end)
    |> Enum.map(&jiffy_opt(&1))
  end

  @spec jiffy_opt({atom, true | non_neg_integer | any}) :: jiffy_opt
  defp jiffy_opt({opt, true}), do: opt
  defp jiffy_opt(opt), do: opt
end
