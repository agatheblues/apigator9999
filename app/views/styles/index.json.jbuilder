json.styles do
  json.array! @styles, partial: 'styles/style', as: :style
end
json.total_styles @styles.size
