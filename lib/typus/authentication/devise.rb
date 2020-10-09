module Typus
  module Authentication
    module Devise

      protected

      include Base

      def admin_user
        send("current_#{Typus.class.name.underscore}")
      end

      def authenticate
        send("authenticate_#{Typus.class.name.underscore}!")
      end

    end
  end
end