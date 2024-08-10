defmodule TrafficLights.Light do
  @moduledoc """
  This module defines the traffic light colors.
  """

  use GenServer

  @doc """
  Starts the light.
  """
  @spec start_link(any()) :: {:ok, pid()}
  def start_link(_args) do
    GenServer.start_link(__MODULE__, [])
  end

  @doc """
  Transitions the light to the next color.

  ## Examples

      iex> {:ok, pid} = TrafficLights.Light.start_link([])
      iex> TrafficLights.Light.transition(pid)
      :ok
  """
  @spec transition(pid()) :: :ok
  def transition(pid) do
    GenServer.cast(pid, :transition)
  end

  @doc """
  Returns the current light color.

  ## Examples

      iex> {:ok, pid} = TrafficLights.Light.start_link([])
      iex> TrafficLights.Light.current_light(pid)
      :green
  """
  @spec current_light(pid()) :: :green | :yellow | :red
  def current_light(pid) do
    GenServer.call(pid, :current_light)
  end

  @impl true
  def init(_init_arg) do
    {:ok, :green}
  end

  @impl true
  def handle_cast(:transition, state) do
    next_state =
      case state do
        :green -> :yellow
        :yellow -> :red
        :red -> :green
      end

    {:noreply, next_state}
  end

  @impl true
  def handle_call(:current_light, _from, state) do
    {:reply, state, state}
  end
end
