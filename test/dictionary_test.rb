# frozen_string_literal: true

require "test_helper"

class DictionaryTest < Minitest::Test
  # This line includes all default Spout Dictionary tests.
  include Spout::Tests

  # This line provides access to @variables, @forms, and @domains iterators
  # iterators that can be used to write custom tests.
  include Spout::Helpers::Iterators

  # Example 1: Create custom tests to show that `integer` and `numeric`
  # variables have a valid unit type.
  VALID_UNITS = ["drinks per week", "hertz (Hz)", "centimeters (cm)", "beats per minute (bpm)", "events per hour", "snores", "arousals",
  "decibels (dB)", "percentage of oxygen saturation", "limb movements per hour", "days from index date", "obstructive apnea events", "stage shifts",
  "seconds from date of randomization",  "limb movements", "leg movements",  "nights",  "intervals", "counts per minute", "desaturations",
  "leg movements per hour", "miles", "kilograms (kg)", "inches (in)", "times", "minutes (min)", "percent (%)", "meters (m)", "meters per second (m/s)",
  "drinks per day", "cigarettes", "kilograms per meter squared (kg/m2)", "drinks", "seconds (s)", "hours (h)", "years", "days", "kilocalorie per week", "blocks per day",
  "gallons per day", "cups", "cans", "", "grams (g)", "grams per centimeters squared", "centimeters squared (cm2)", "millimeters (mm)", "milligrams per day", "falls",
  "fractures", "microvolts squared per hertz (uV2/Hz)", "periodic limb movements", "millimeters of mercury (mmHg)", "events", ""] # Add your own valid units to this array
  @variables.select { |v| %w(numeric integer).include?(v.type) }.each do |variable|
    define_method("test_units: #{variable.path}") do
      message = "\"#{variable.units}\"".red + " invalid units.\n" +
                "             Valid types: " +
                VALID_UNITS.sort_by(&:to_s).collect { |u| u.inspect.white }.join(", ")
      assert VALID_UNITS.include?(variable.units), message
    end
  end

  # Example 2: Create custom tests to show that variables have 2 or more labels.
  # @variables.select { |v| %w(numeric integer).include?(v.type) }.each do |variable|
  #   define_method("test_at_least_two_labels: #{variable.path}") do
  #     assert_operator 2, :<=, variable.labels.size
  #   end
  # end

  # Example 3: Create regular Ruby tests
  # You may add additional tests here
  # def test_truth
  #   assert true
  # end
end
