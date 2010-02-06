module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end
  
  def tag_cloud(tags, classes)
    group = {}
    tags.each { |t|
      group[t] = (group[t] || 1) + 1
    }

    values = group.values    
    divisor = ((values.max - values.min) / classes.size) + 1

    group.each { |key, value|
      yield key, classes[(value - values.min) / divisor]
    }
  end  
end
