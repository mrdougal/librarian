require 'haml'

module Sinatra::Templates
  alias :haml_orig :haml
  def haml(template, options={})
    options = options.merge!(:layout => false) if template.to_s.start_with? '_'
    haml_orig template, options
  end
end

def render_objects(sym, resource, key=nil)
  haml sym, :locals => {
    sym => key.nil? ? resource.all : resource.first(key => params[key])
   }
end

def create_partial(sym, code)
  template sym, &lambda { code }
end

PAT_ROUTEKEY = Regexp.compile('(.*):([^/]+)(.*?$)')
def create_get(route, resource)
  m = PAT_ROUTEKEY.match(route)
  key = m && m.captures[1].to_sym
	name = resource.storage_name
  name = name.singular unless key.nil?
  get route, &lambda { render_objects name.to_sym, resource, key }
  partial = m.nil? ?
    "%a(href='#{route}')> all #{name}" :
    "%a(href='#{m.captures[0]}#"+"{#{name}.#{key}}#{m.captures[2]}')= #{name}"
	create_partial "_#{name}_a".to_sym, partial
end


def link_to(object)
  name = object.class.storage_name.singular
	haml "_#{name}_a".to_sym, :locals => { name.to_sym => object }
end
