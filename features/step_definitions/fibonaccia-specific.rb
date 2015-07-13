Given(%r!the internal series (?:is|has been) reset$!) do
  @exemplar.reset
end

When(%r!^I (?:query|invoke) (?:attribute|method) ["']?([_A-Za-z0-9?]+)["']?\((.*?)\)["']?$!) do |attr,args|
  args		= eval("[#{args}]")
  wrap_exception do
    @exemplar.send(attr.to_sym, *args)
  end
end

When(%r!^I (?:query|invoke) (?:attribute|method) ["']?\[(.*)\]["']?$!) do |args|
  args		= eval("[#{args}]")
  wrap_exception do
    @exemplar.send(:[], *args)
  end
end

When(%r!^I (?:query|invoke) (?:attribute|method):$!) do |xval|
  wrap_exception do
    eval(xval)
  end
end

When(%r!^I (?:query|invoke) (?:attribute|method) ["']?([_A-Za-z0-9?]+)["']?$!) do |attr|
  wrap_exception do
    @exemplar.send(attr.to_sym)
  end
end

When(%r!^I set (?:attribute|the)?\s*["']?([_A-Za-z0-9]+)["']? to (.+?)$!) do |attr,val|
  wrap_exception do
    @exemplar.send((attr. + '=').to_sym, eval(val))
  end
end

