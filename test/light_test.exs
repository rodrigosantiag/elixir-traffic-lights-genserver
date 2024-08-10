defmodule TrafficLights.LightTest do
  use ExUnit.Case
  doctest TrafficLights.Light

  alias TrafficLights.Light

  describe "start_link1" do
    test "starts the light" do
      {:ok, pid} = Light.start_link([])
      assert :sys.get_state(pid) == :green
    end
  end

  describe "transition/1" do
    test "should transition from green to yellow, from yellow to red and from red to green again (and so on)" do
      {:ok, pid} = Light.start_link([])
      assert :sys.get_state(pid) == :green
      Light.transition(pid)
      assert :sys.get_state(pid) == :yellow
      Light.transition(pid)
      assert :sys.get_state(pid) == :red
      Light.transition(pid)
      assert :sys.get_state(pid) == :green
    end
  end

  describe "current_light/1" do
    test "should return the current light" do
      {:ok, pid} = Light.start_link([])
      assert Light.current_light(pid) == :green
      Light.transition(pid)
      assert Light.current_light(pid) == :yellow
      Light.transition(pid)
      assert Light.current_light(pid) == :red
    end
  end
end
