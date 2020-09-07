# Module designed to work with `rails-trash`.

require 'active_support/concern'

module Admin
  module Trash

    extend ActiveSupport::Concern

    included do
      before_action :set_predefined_filter_for_trash, only: [:index, :trash]
    end

    def set_predefined_filter_for_trash
      if admin_user.can?('edit', @resource.model_name)
        add_predefined_filter('typus.filters.trash', 'trash', 'deleted')
      end
    end
    private :set_predefined_filter_for_trash

    def trash
      set_deleted

      get_objects

      respond_to do |format|
        format.html do
          # Actions by resource.
          add_resource_action 'typus.buttons.restore', { action: 'restore' }, { glyphicon: 'refresh', data: { confirm: I18n.t('typus.shared.restore_question', resource: @resource.model_name.human) } }
          add_resource_action 'typus.buttons.destroy_permanently', { action: 'wipe' }, { glyphicon: 'remove', data: { confirm: I18n.t('typus.shared.confirm_question') } }
          # Generate and render.
          get_paginated_data
          render 'index'
        end

        format.csv { generate_csv }
        format.json { export(:json) }
        format.xml { export(:xml) }
      end
    end

    def restore
      begin
        @resource.restore(params[:id])
        message = I18n.t('typus.flash.trash_recover_success', resource: @resource.model_name.human)
      rescue ActiveRecord::RecordNotFound
        message = I18n.t('typus.flash.trash_recover_failed', resource: @resource.model_name.human)
      end

      redirect_to :back, notice: message
    end

    def wipe
      item = @resource.find_in_trash(params[:id])
      item.disable_trash { item.destroy }
      redirect_to :back, notice: I18n.t('typus.flash.wipe_success', resource: @resource.model_name.human)
    end

    def set_deleted
      @resource = @resource.deleted
    end
    private :set_deleted

  end
end
