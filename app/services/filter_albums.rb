class FilterAlbums
  def self.call(*args)
    new(*args).call
  end

  def call
    return @relation if @filter_params.empty?
    
    @relation = @relation.joins(:genres) if @filter_params.has_key?('genres')
    @relation = @relation.joins(:styles) if @filter_params.has_key?('styles')

    @relation.where(@filter_params).distinct
  end

  private 
  
  def initialize(relation, params)
    @relation = relation
    @filter_params = filters(params)
  end

  def filters(params)
    filters = {}
    filters['genres'] = format_params(params, 'genres', Proc.new {|list| {:id => list}}) if has_param(params, 'genres')
    filters['styles'] = format_params(params, 'styles', Proc.new {|list| {:id => list}}) if has_param(params, 'styles')
    filters
  end

  def has_param(params, key)
    params.has_key?(key) && !params[key].nil?
  end

  def format_params(params, name, formatter)
    formatter.call(params[name].split(","))
  end
end