module MetricsHelper
  
  def rounded_value(value)
    number_with_precision(value, :precision => 2, :strip_insignificant_zeros => true)
  end
  
  def value_per_state_value_list(values)
    values.map{|a| rounded_value(a[1].to_f) if a[1].to_f > 0}.compact.join(',')
  end
  
  def value_per_state_legend_list(values)
    raw values.map{|a| "\"#{a[0]}: #{rounded_value(a[1].to_f)} (%%.%%)\"" if a[1].to_f > 0}.compact.join(',')
  end
  
  def time_per_state_value_list(values)
    values.map{|a| rounded_value(a[1].to_f) if a[1].to_f > 0 && !['won', 'lost', 'hold'].include?(a[0])}.compact.join(',')
  end
  
  def time_per_state_legend_list(values)
    raw values.map{|a| "\"#{a[0]} (%%.%%)\"" if a[1].to_f > 0 && !['won', 'lost', 'hold'].include?(a[0])}.compact.join(',')
  end
end
