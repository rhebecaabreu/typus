require 'active_support/concern'

module Admin
  module Bulk

    extend ActiveSupport::Concern

    included do
      helper_method :bulk_actions
      before_action :set_bulk_action, only: [:index]
      before_action :set_bulk_action_for_trash, only: [:trash]
    end

    def set_bulk_action
      add_bulk_action('typus.buttons.destroy', 'bulk_destroy')
    end
    private :set_bulk_action

    # This only happens if we try to access the trash, which won't happen
    # if trash module is not loaded.
    def set_bulk_action_for_trash
      add_bulk_action('Restore from Trash', 'bulk_restore')
    end
    private :set_bulk_action_for_trash

    def bulk
      if params[:selected_item_ids] && params[:batch_action].present?
        send(params[:batch_action], params[:selected_item_ids])
      else
        notice = if params[:batch_action].empty?
          I18n.t('typus.flash.bulk_no_action')
        else
          I18n.t('typus.flash.bulk_no_items')
        end
        redirect_to :back, notice: notice
      end
    end

    def bulk_destroy(ids)
      ids.each { |id| @resource.destroy(id) }
      notice = I18n.t('typus.flash.bulk_delete_success', count: ids.count)
      redirect_to :back, notice: notice
    end
    private :bulk_destroy

    def bulk_restore(ids)
      ids.each { |id| @resource.deleted.find(id).restore }
      notice = I18n.t('Successfully restored %{count} entries.', count: ids.count)
      redirect_to :back, notice: notice
    end
    private :bulk_restore

    def add_bulk_action(*args)
      bulk_actions
      @bulk_actions << args unless args.empty?
    end
    protected :add_bulk_action

    def prepend_bulk_action(*args)
      bulk_actions
      @bulk_actions = @bulk_actions.unshift(args) unless args.empty?
    end
    protected :prepend_bulk_action

    def append_bulk_action(*args)
      bulk_actions
      @bulk_actions = @bulk_actions.concat([args]) unless args.empty?
    end
    protected :append_bulk_action

    def bulk_actions
      @bulk_actions ||= []
    end

  end
end
