module Admin::Resources::SidebarHelper

  def build_sidebar
    locals = { :sidebar_title => Typus::I18n.t("Dashboard"), :actions => []}

    if @resource
      locals[:actions] = [sidebar_list(@resource.name), sidebar_add_new(@resource.name)].compact
      locals[:sidebar_title] = @resource.model_name.human.pluralize
    end

    locals[:extra_actions] = [sidebar_dashboard, sidebar_help, sidebar_view_site].compact

    render "helpers/admin/resources/sidebar", locals
  end

  def sidebar_add_new(klass)
    if admin_user.can?("create", klass)
      { :message => Typus::I18n.t("Add"),
        :url => { :controller => "/admin/#{klass.to_resource}", :action => "new" },
        :icon => "plus" }
    end
  end

  def sidebar_list(klass)
    if admin_user.can?("read", klass)
      { :message => Typus::I18n.t("List"),
        :url => { :controller => "/admin/#{klass.to_resource}", :action => "index" },
        :icon => "list" }
    end
  end

  def sidebar_dashboard
    { :message => Typus::I18n.t("Dashboard"),
      :url => admin_dashboard_index_path,
      :icon => "home" }
  end

  def sidebar_help
    { :message => Typus::I18n.t("Help"),
      :url => "#",
      :icon => "info-sign" }
  end

  def sidebar_view_site
    if Typus.admin_title_link
      { :message => Typus::I18n.t("View Site"),
        :url => Typus.admin_title_link,
        :icon => "share" }
    end
  end

  # def sidebar_actions
  #   resources_actions_for_current_role.map do |body, url, options|
  #     path = params.dup.merge!(url).compact.cleanup
  #     { :message => Typus::I18n.t(body), :url => path, :options => options }
  #     # link_to , path, options
  #   end.compact #.reverse.join(" / ").html_safe
  # end

end