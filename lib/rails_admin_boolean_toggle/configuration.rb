module RailsAdminBooleanToggle
  class Configuration
    def initialize(abstract_model)
      @abstract_model = abstract_model
    end

    def options
      @options ||= {
        wrapper_tag: 'div',
        wrapper_html_attributes: 'class="btn-group" role="group"',
        item_tag: 'a',
        item_class: 'btn btn-mini btn-xs'
      }.merge(config)
      @options
    end

    def wrapper_tag
      options[:wrapper_tag]
    end

    def wrapper_html_attributes
      options[:wrapper_html_attributes]
    end

    def item_tag
      options[:item_tag]
    end

    def item_class
      options[:item_class]
    end

    protected

    def config
      begin
        opt = ::RailsAdmin::Config.model(@abstract_model.model).state
        if opt.nil?
          {}
        else
          opt
        end
      rescue
        {}
      end
    end
  end
end
