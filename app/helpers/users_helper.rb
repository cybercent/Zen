module UsersHelper
  def error_messages!
    return "" if @user.errors.empty?
    messages = @user.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved", :count => @user.errors.count, :resource => "user")
    
    html = <<-HTML
      <div id="error_explanation">
        <h2>#{sentence}</h2>
        <ul>#{messages}</ul>
      </div>
    HTML
      
    html.html_safe
  end
  
end
