module ReadingTimeFilter
  include Liquid::StandardFilters

  def reading_time(input)
    # Get words count.
    total_words = get_plain_text(input).split.size
    # Average reading words per minute.
    words_per_minute = 180
    # Calculate reading time.
    if total_words < 90
      minutes = 0
    elsif total_words < 270
      minutes = 1
    else
      minutes = (total_words / words_per_minute ).floor
    end
    return convert_reading_min(minutes)
  end

  def convert_reading_min(minutes)
    title = "Время чтения"

    if minutes < 1
      return "#{title}: меньше минуты"
    end

    n1 = minutes % 100
    n2 = minutes % 10

    if (n1 >= 11 and n1 <= 19) or (n2 >= 5) or (n2 == 0)
      return "#{title}: #{minutes} минут";
    elsif n2 == 1
      return "#{title}: #{minutes} минута";
    else
      return "#{title}: #{minutes} минуты";
    end

    if minutes < 1

    elsif minutes == 1
      return "#{title}: 1 #{minute_singular}"
    else
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
