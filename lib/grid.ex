defmodule TrafficLights.Grid do
  @moduledoc """
  This module defines the traffic light grid.
  """

  use GenServer

  alias TrafficLights.Light

  @doc """
  Starts the grid.
  """
  @spec start_link(any()) :: {:ok, pid()}
  def start_link(_args) do
    GenServer.start_link(__MODULE__, [])
  end

  @doc """
  Transitions one light per time in traffic lights grid.
  """
  @spec transition(pid()) :: :ok
  def transition(pid) do
    GenServer.cast(pid, :transition)
  end

  @doc """
  Returns the current lights in the grid.
  """
  @spec current_lights(pid()) :: [atom()]
  def current_lights(pid) do
    GenServer.call(pid, :current_lights)
  end

  @impl true
  def init(_init_arg) do
    traffic_light_pids =
      Enum.map(1..5, fn _ ->
        {:ok, pid} = TrafficLights.Light.start_link([])
        pid
      end)

    {:ok, [traffic_lights_pids: traffic_light_pids, transition_index: 0]}
  end

  @impl true
  def handle_cast(:transition, state) do
    traffic_lights_pids = state[:traffic_lights_pids]
    transition_index = state[:transition_index]
    current_light_pid = Enum.at(traffic_lights_pids, transition_index)

    Light.transition(current_light_pid)

    next_transaction_index = rem(transition_index + 1, length(traffic_lights_pids))

    {:noreply,
     [traffic_lights_pids: traffic_lights_pids, transition_index: next_transaction_index]}
  end

  @impl true
  def handle_call(:current_lights, _from, state) do
    lights = Enum.map(state[:traffic_lights_pids], fn pid -> Light.current_light(pid) end)
    {:reply, lights, state}
  end
end
