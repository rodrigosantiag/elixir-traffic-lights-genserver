defmodule TrafficLights.GridTest do
  use ExUnit.Case
  doctest TrafficLights.Grid

  alias TrafficLights.Grid
  alias TrafficLights.Light

  describe "start_link/1" do
    test "starts the grid" do
      {:ok, pid} = Grid.start_link([])

      assert [traffic_lights_pids: [_pid1, _pid2, _pid3, _pid4, _pid5], transition_index: 0] =
               :sys.get_state(pid)
    end
  end

  describe "transition/1" do
    test "should transition one light every transition sequentially" do
      {:ok, pid} = Grid.start_link([])

      assert [traffic_lights_pids: [pid1, pid2, pid3, pid4, pid5], transition_index: 0] =
               :sys.get_state(pid)

      assert Light.current_light(pid1) == :green
      assert Light.current_light(pid2) == :green
      assert Light.current_light(pid3) == :green
      assert Light.current_light(pid4) == :green
      assert Light.current_light(pid5) == :green

      Grid.transition(pid)

      assert [traffic_lights_pids: [pid1, pid2, pid3, pid4, pid5], transition_index: 1] =
               :sys.get_state(pid)

      assert Light.current_light(pid1) == :yellow
      assert Light.current_light(pid2) == :green
      assert Light.current_light(pid3) == :green
      assert Light.current_light(pid4) == :green
      assert Light.current_light(pid5) == :green

      Grid.transition(pid)

      assert [traffic_lights_pids: [pid1, pid2, pid3, pid4, pid5], transition_index: 2] =
               :sys.get_state(pid)

      assert Light.current_light(pid1) == :yellow
      assert Light.current_light(pid2) == :yellow
      assert Light.current_light(pid3) == :green
      assert Light.current_light(pid4) == :green
      assert Light.current_light(pid5) == :green
    end
  end

  describe "current_lights/1" do
    test "should return all lights in the traffic lights grid" do
      {:ok, pid} = Grid.start_link([])

      assert [:green, :green, :green, :green, :green] == Grid.current_lights(pid)

      Grid.transition(pid)

      assert [:yellow, :green, :green, :green, :green] == Grid.current_lights(pid)
    end
  end
end
