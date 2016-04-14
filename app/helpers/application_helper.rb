module ApplicationHelper
  def flash_class(level)
    case level
      when :notice then "info"
      when :alert then "danger"
    end
  end
end
