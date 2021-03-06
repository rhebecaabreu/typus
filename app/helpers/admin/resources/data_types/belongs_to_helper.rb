module Admin::Resources::DataTypes::BelongsToHelper
  def typus_belongs_to_field(attribute, form)
    association = @resource.reflect_on_association(attribute.to_sym)

    related = if defined?(set_belongs_to_context)
      set_belongs_to_context.send(attribute.pluralize.to_sym)
    else
      association.class_name.constantize
    end

    related_fk = association.foreign_key
    label_text = @resource.human_attribute_name(attribute)

    values = if related.respond_to?(:roots) && related.respond_to?(:ancestry_column)
      expand_tree_into_select_field(related.roots, related_fk)
    else
      related.order(related.typus_order_by).map { |p| [p.to_label, p.id] }
    end

    attribute_id = "#{@resource.name.underscore}_#{attribute}_id".gsub('/', '_')

    locals = {
      attribute: attribute,
      attribute_id: attribute_id,
      form: form,
      related_fk: related_fk,
      related: related,
      label_text: label_text.html_safe,
      values: values,
      html_options: { class: 'form-control' },
      options: { include_blank: true, attribute: "#{@resource.name.underscore}_#{related_fk}" }
    }

    render 'admin/templates/belongs_to', locals
  end

  def table_belongs_to_field(attribute, item)
    if att_value = item.send(attribute)
      action = item.send(attribute).class.typus_options_for(:default_action_on_item)
      message = att_value.to_label
      if !params[:_popup] && admin_user.can?(action, att_value.class.name)
        message = link_to(message, controller: "/admin/#{att_value.class.to_resource}", action: action, id: att_value.id)
      end
    end

    message || mdash
  end

  def display_belongs_to(item, attribute)
    data = item.send(attribute)

    options = {
      controller: data.class.to_resource,
      action: params[:action],
      id: data.id,
    }

    params[:_popup] ? data.to_label : link_to(data.to_label, options)
  end

  def belongs_to_filter(filter)
    att_assoc = @resource.reflect_on_association(filter.to_sym)
    class_name = att_assoc.options[:class_name] || filter.capitalize.camelize
    resource = class_name.constantize

    attribute = @resource.human_attribute_name(filter)

    items = [[attribute, '']]
    array = resource.order(resource.typus_order_by).map { |v| ["#{attribute}:#{v.to_label}", v.id] }

    items + array
  end

  def build_label_text_for_belongs_to(klass, html_options, options)
    if html_options[:disabled] == true
      t('typus.labels.read_only')
    elsif admin_user.can?('create', klass) && !headless_mode?
      build_add_new_for_belongs_to(klass, options)
    end
  end

  def build_add_new_for_belongs_to(klass, options)
    html_options = set_modal_options_for(klass)
    html_options['data-controls-modal'] = "modal-from-dom-#{options[:attribute]}"
    html_options['url'] = "/admin/#{klass.to_resource}/new?_popup=true"

    link_to t('typus.buttons.add'), { anchor: html_options['data-controls-modal'] }, html_options
  end
end
