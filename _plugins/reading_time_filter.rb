module ReadingTimeFilter
  include Liquid::StandardFilters

  def reading_time(input)
    # Get words count.
    total_words = get_plain_text(input).split.size

    # Load configuration.
    config = @context.registers[:site].config["reading_time"]

    # Setup default value.
    if ! config
      title = "Reading time"
      less_then_minute = "less then minute"
      minute_singular = "minute"
      minute_plural = "minutes"
    else
      title = config["title"] ? config["title"] : "Reading time"
      less_then_minute = config["less_then_minute"] ? config["less_then_minute"] : "less then minute"
      minute_singular = config["minute_singular"] ? config["minute_singular"] : "minute"
      minute_plural = config["minute_plural"] ? config["minute_plural"] : "minutes"
    end

    # Average reading words per minute.
    words_per_minute = 180

    # Calculate reading time.
    case total_words
    when 0 .. 89
      return "#{title}: #{less_then_minute}"
    when 90 .. 269
      return "#{title}: 1 #{minute_singular}"
    else
      minutes = ( total_words / words_per_minute ).floor
      return "#{title}: #{minutes} #{minute_plural}";
    end
  end

  def get_plain_text(input)
    strip_html(strip_pre_tags(input))
  end

  def strip_pre_tags(input)
    empty = ''.freeze
    input.to_s.gsub(/<pre(?:(?!<\/pre).|\s)*<\/pre>/mi, empty)
  end
end

Liquid::Template.register_filter(ReadingTimeFilter)
