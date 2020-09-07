class Admin::AccountController < Admin::BaseController

  layout 'admin/session'

  skip_before_action :reload_config_and_roles, :authenticate, :set_locale

  before_action :sign_in?, except: [:forgot_password, :send_password, :show]
  before_action :new?, only: [:forgot_password, :send_password]

  def new
  end

  def create
    user = Typus.user_class.generate(email: admin_user_params[:email])
    redirect_to user ? { action: 'show', id: user.token } : { action: :new }
  end

  def forgot_password
  end

  def send_password
    if user = Typus.user_class.find_by_email(admin_user_params[:email])
      Admin::Mailer.reset_password_instructions(user, request.host_with_port).deliver_later
      redirect_to new_admin_session_path, notice: I18n.t('typus.flash.password_reset_email_success')
    else
      render action: :forgot_password
    end
  end

  def show
    flash[:notice] = I18n.t('typus.flash.set_new_password')
    typus_user = Typus.user_class.find_by_token!(params[:id])
    session[:typus_user_id] = typus_user.id
    redirect_to params[:return_to] || { controller: "/admin/#{Typus.user_class.to_resource}", action: 'edit', id: typus_user.id }
  end

  private

  def sign_in?
    redirect_to new_admin_session_path unless zero_users
  end

  def new?
    redirect_to new_admin_account_path if zero_users
  end

end
