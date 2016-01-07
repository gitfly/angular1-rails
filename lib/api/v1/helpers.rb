module API::V1::Helpers
  extend ActiveSupport::Concern

  included do
    helpers do

      def current_token; env['api.token']; end

      def current_resource_owner
        User.find(current_token.resource_owner_id) if current_token
      end

      def current_user
        @current_user ||= current_resource_owner
        # @current_user ||= env['warden'].try(:user)
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end

      def authorize!(action, object)
        GrapePermission.new(current_user).authorize!(action, object)
      end

      def object_to_hash(object, *attrs)
        {}.tap do |hash|
          attrs.each do |attr|
            hash[attr.to_sym] = object.send(attr)
          end
        end
      end

    end
  end
end
