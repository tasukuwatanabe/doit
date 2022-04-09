module ErrorModule
  extend ActiveSupport::Concern

  def format_errors(model)
    model.errors.keys.map { |key| [key, model.errors.full_messages_for(key)[0]] }.to_h
  end
end