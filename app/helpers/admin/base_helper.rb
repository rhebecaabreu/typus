module Admin::BaseHelper

  # a simple wrapper to prevent repeating "typus." in the key name
  def tt(key, options = {})
    t(key, {scope: "typus.#{options[:scope]}"}.merge(options))
  end

  def admin_title(page_title = nil)
    if page_title
      content_for(:title) { page_title }
    else
      setting = defined?(Admin::Setting) && Admin::Setting.admin_title
      setting || Typus.admin_title
    end
  end

  def admin_sign_out_path
    case Typus.authentication
    when :devise
      send("destroy_#{Typus.class.name.underscore}_session_path")
    else
      destroy_admin_session_path
    end
  end

  def admin_edit_user_path(user)
    {
      controller: "/admin/#{Typus.class.to_resource}",
      action: 'edit',
      id: user.id,
    }
  end

  def admin_display_flash_message
    if flash.any?
      String.new.tap do |html|
        flash.each do |type, message|
          type = 'info' if type.to_sym == :notice
          html << content_tag(:div, message, id: 'flash', class: "alert alert-#{type}")
        end
      end.html_safe
    end
  end

  def set_modal_options_for(klass)
    {
      'data-toggle' => 'modal',
      'data-controls-modal' => "modal-from-dom-#{klass.to_resource}",
      'data-backdrop' => 'true',
      'data-keyboard' => 'true',
      'class' => 'ajax-modal',
      'url' => 'override-this',
    }
  end

  def body_class
    klass = %w(base)
    klass << 'dashboard' if params[:controller] == 'admin/dashboard'
    klass << @resource.model_name.human.parameterize if @resource.try(:model_name)
    klass << action_name.parameterize
    klass.join(' ')
  end

  def typus_search_path
    path = controller_name
    path = Typus.subdomain.nil? ? "/admin/#{path}" : "/#{path}"
    path
  end

end
