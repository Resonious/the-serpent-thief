class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  [:text_field, :password_field, :text_area, 
  :number_field, :check_box, :email_field].each do |method_name|
    alias_method "original_#{method_name}".to_sym, method_name
    define_method method_name do |*args|
      options = args.count == 2 ? args.last.merge({}) : {}
      add_class options, 'form-control'
      add_class(options, 'number_field') if method_name == :number_field
      actual_args = [args.first, options]
      send("original_#{method_name}".to_sym, *actual_args)
    end
  end

  def submit(value=nil, options={})
    add_class options, 'submit', 'btn', 'btn-primary'
    super
  end

  def error_for(method)
    if @object.errors.include? method
      content = @object.errors.full_messages_for(method).collect do |message|
        @template.content_tag(:p, message, class: 'text-danger', for: "#{@object_name}[#{method}]")
      end.join

      @template.content_tag(:div, content, {class: 'error'}, false)
    end
  end

  private
  def add_class(options, *values)
    options[:class] ||= ''
    values.each do |v|
      options[:class] << ' ' unless options[:class].empty?
      options[:class] << v
      options.merge!(@common_attrs) unless @common_attrs.nil?
    end
  end
end