module RailsAdmin
  module Config
    module Actions
      class BooleanToggle < Base
        RailsAdmin::Config::Actions.register(self)

        # Is the action acting on the root level (Example: /admin/contact)
        register_instance_option :root? do
          false
        end

        register_instance_option :collection? do
          false
        end

        # Is the action on an object scope (Example: /admin/team/1/edit)
        register_instance_option :member? do
          true
        end

        register_instance_option :controller do
          Proc.new do |klass|
            if @authorization_adapter
              @authorization_adapter.try(:authorize, :update, @abstract_model, @object)
            end

            if params['id'].present?
              begin
                current_value = @object.send(params[:field])
                if @object.update_attribute(params[:field], !current_value)
                  flash[:success] = I18n.t('admin.boolean_toggle.toggled', field: params[:field])
                else
                  flash[:error] = obj.errors.full_messages.join(', ')
                end
              rescue StandardError => e
                Rails.logger.error e
                flash[:error] = I18n.t('admin.boolean_toggle.error', err: e.to_s)
              end
            else
              flash[:error] = I18n.t('admin.boolean_toggle.no_id')
            end
            redirect_to :back
          end
        end

        register_instance_option :http_methods do
          [:post]
        end
      end
    end
  end
end
