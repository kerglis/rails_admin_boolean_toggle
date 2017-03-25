require 'builder'

module RailsAdmin
  module Config
    module Fields
      module Types
        class State < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)
          include RailsAdmin::Engine.routes.url_helpers

          register_instance_option :pretty_value do
            @state_machine_options = ::RailsAdminBooleanToggle::Configuration.new @abstract_model
            v = bindings[:view]

            state = bindings[:object].send(name)
            state_class = @state_machine_options.state(state)
            ret = [
              build_current_state_obj(bindings[:object].aasm(state_machine_name).human_state, state_class)
            ]

            unless read_only
              bindings[:object].aasm(state_machine_name).events.map(&:name).each do |event|
                next if @state_machine_options.disabled?(event) || !bindings[:object].send("may_#{event}?")
                unless bindings[:controller].try(:authorization_adapter).nil?
                  adapter = bindings[:controller].authorization_adapter
                  next unless (adapter.authorized?(:state, @abstract_model, bindings[:object]) && (adapter.authorized?(:all_events, @abstract_model, bindings[:object]) || adapter.authorized?(event, @abstract_model, bindings[:object])))
                end
                event_class = @state_machine_options.event(event)
                ret << bindings[:view].link_to(
                  bindings[:object].class.aasm.human_event_name(event),
                  state_path(model_name: @abstract_model, id: bindings[:object].id, event: event, attr: name),
                  method: :post,
                  class: "btn btn-mini btn-xs #{event_class}",
                  style: 'margin-bottom: 5px;'
                )
              end
            end

            build_output(ret)
          end

          register_instance_option :formatted_value do
            form_value
          end

          register_instance_option :form_value do
            @state_machine_options = ::RailsAdminBooleanToggle::Configuration.new @abstract_model
            c = bindings[:controller]
            v = bindings[:view]

            state = bindings[:object].send(name)
            state_class = @state_machine_options.state(state)
            ret = [
              build_current_state_obj(bindings[:object].aasm(state_machine_name).human_state, state_class)
            ]

            unless read_only
              bindings[:object].aasm(state_machine_name).events.map(&:name).each do |event|
                next if @state_machine_options.disabled?(event) || !bindings[:object].send("may_#{event}?")
                unless bindings[:controller].try(:authorization_adapter).nil?
                  adapter = bindings[:controller].authorization_adapter
                  next unless (adapter.authorized?(:state, @abstract_model, bindings[:object]) && (adapter.authorized?(:all_events, @abstract_model, bindings[:object]) || adapter.authorized?(event, @abstract_model, bindings[:object])))
                end
                event_class = @state_machine_options.event(event)
                ret << bindings[:view].link_to(
                  bindings[:object].class.aasm.human_event_name(event),
                  state_path(model_name: @abstract_model, id: bindings[:object].id, event: event, attr: name),
                  method: :post,
                  'data-attr' => name,
                  'data-event' => event,
                  class: "state-btn btn btn-mini btn-xs #{event_class}",
                  style: 'margin-bottom: 5px;'
                )
              end
            end

            build_output(ret)
          end

          register_instance_option :export_value do
            state = bindings[:object].send(name)
            bindings[:object].aasm(state_machine_name).human_state
          end

          register_instance_option :partial do
            :form_state
          end

          register_instance_option :read_only do
            false
          end

          register_instance_option :allowed_methods do
            [method_name, (method_name.to_s + '_event').to_sym]
          end

          register_instance_option :multiple? do
            false
          end

          register_instance_option :searchable_columns do
            @searchable_columns ||= begin
              if searchable
                [
                  {
                    column: "#{abstract_model.table_name}.#{name}",
                    type: :string
                  }
                ]
              else
                []
              end
            end
          end

          register_instance_option :state_machine_name do
            @state_machine_name || :default
          end

          private

          def build_current_state_obj(state, state_class)
            tag = @state_machine_options.current_state_tag
            style = @state_machine_options.current_state_style
            "<#{tag} #{style} class='btn btn-mini btn-xs #{state_class}'>#{state}</#{tag}>"
          end

          def build_output(ret)
            wrapper_style = @state_machine_options.wrapper_style

            [
              "<div #{wrapper_style}>",
              ret.join(' '),
              '</div>'
            ].join.html_safe
          end
        end
      end
    end
  end
end
