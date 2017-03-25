require 'builder'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BooleanToggle < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          include RailsAdmin::Engine.routes.url_helpers

          register_instance_option :pretty_value do
            value = bindings[:object].send(name)

            if value
              css_class = 'btn-success'
              icon = 'icon-check'
            else
              css_class = 'btn-default'
              icon = 'icon-minus'
            end

            unless read_only
              bindings[:view].link_to(
                "<i class='#{icon}'></i>".html_safe,
                boolean_toggle_path(model_name: @abstract_model, id: bindings[:object].id, field: name),
                method: :post,
                class: "btn btn-mini btn-xs #{css_class}"
              )
            end
          end

          register_instance_option :formatted_value do
            form_value
          end

          register_instance_option :form_value do
            pretty_value
          end

          register_instance_option :export_value do
            bindings[:object].send(name)
          end

          register_instance_option :partial do
            :boolean_toggle
          end

          register_instance_option :read_only do
            false
          end

          register_instance_option :allowed_methods do
            [method_name]
          end

          register_instance_option :multiple? do
            false
          end

          register_instance_option :searchable_columns do
            []
          end

        end
      end
    end
  end
end
