module FilterAlbums
  def filter(relation)
    return relation if filter_params.empty?
    
    relation = relation.joins(:genres) if filter_params.has_key?('genres')
    relation = relation.joins(:styles) if filter_params.has_key?('styles')

    relation.where(filter_params).distinct
  end

  private

  def filter_params
    filter_params = {}
    filter_params['genres'] = format_params(params, 'genres', Proc.new {|list| {:id => list}}) if has_param(params, :genres)
    filter_params['styles'] = format_params(params, 'styles', Proc.new {|list| {:id => list}}) if has_param(params, :styles)
    filter_params
  end

  def has_param(params, key)
    params.has_key?(key) && !params[key].nil?
  end

  def format_params(params, name, formatter)
    formatter.call(params[name].split(","))
  end
end