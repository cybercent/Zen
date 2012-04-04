module ProjectsHelper
  def transition_tag(enter_state, exit_state)
    raw "#{enter_state.capitalize} &rarr; #{exit_state.capitalize}"
  end
  
  def project_states(project)
    states = Project.ordered_states
    list = ''
    css_class = ''
    current_index = states.index(project.aasm_state.to_sym) || -1
    states.each_with_index do |state, idx|
      css_class = idx < current_index ? 'past' : idx == current_index ? 'current' : ''
      list = list + "<li class=\"pos-#{idx+1} #{css_class}\" data-state=\"#{state.to_s}\">#{state.to_s.capitalize}</li>"
    end
    raw "<ol class=\"states\">#{list}</ol>"
  end
  
  def formatted_exact_value(value)
    number_with_precision(value, :precision => 2, :strip_insignificant_zeros => true)
  end
  
  def formatted_estimate_value(value)
    raw(Settings.estimate_tag * (value || 0))
  end
  
  def formatted_value(project)
    if project.exact_value
      formatted_exact_value(project.exact_value)
    elsif project.estimate_value
      formatted_estimate_value(project.estimate_value)
    end
  end
end
