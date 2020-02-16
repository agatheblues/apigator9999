# frozen_string_literal: true

class CreateOrUpdateStyles
  def self.call(*args)
    new(*args).call
  end

  def call
    ActiveRecord::Base.transaction do
      @styles.map do |style_params|
        existing_style = Style.find_by(name: style_params['name'])
        if existing_style.nil?
          create_style(style_params)
        else
          update_style(existing_style, style_params)
        end
      end
    end
  end

  private

  def initialize(styles)
    @styles = styles
  end

  def get_total_albums(current_albums)
    current_albums + 1
  end

  def create_style(attrs)
    attrs = attrs.merge('total_albums' => get_total_albums(0))
    Style.create!(attrs)
  end

  def update_style(existing_style, attrs)
    attrs = attrs.merge('total_albums' => get_total_albums(existing_style['total_albums']))
    existing_style.update(attrs)
    existing_style
  end
end
