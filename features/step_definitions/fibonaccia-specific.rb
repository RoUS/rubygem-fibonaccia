Given(%r!the internal series (?:is|has been) reset$!) do
  @exemplar.reset
end

When(%r!^I (?:query|invoke) (?:attribute|method) ["']?([\[\]_=A-Za-z0-9?]+)["']?\((.*?)\)["']?$!) do |attr,args|
  args		= eval("[#{args}]")
  @return_value	= wrap_exception {
    @exemplar.send(attr.to_sym, *args)
  }
end

When(%r!^I (?:query|invoke) (?:attribute|method) ["']?\[(.*)\]["']?$!) do |args|
  args		= eval("[#{args}]")
  @return_value	= wrap_exception {
    @exemplar.send(:[], *args)
  }
end

When(%r!^I (?:query|invoke) (?:attribute|method):$!) do |xval|
  @return_value	= wrap_exception {
    eval(xval)
  }
end

When(%r!^I (?:query|invoke) (?:attribute|method) ["']?([_A-Za-z0-9?]+)["']?$!) do |attr|
  @return_value	= wrap_exception {
    @exemplar.send(attr.to_sym)
  }
end

When(%r!^I set (?:attribute|the)?\s*["']?([_A-Za-z0-9]+)["']? to (.+?)$!) do |attr,val|
  @return_value	= wrap_exception {
    @exemplar.send((attr. + '=').to_sym, eval(val))
  }
end

