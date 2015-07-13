Then(%r!^I should get a warning about '(.*)' on stderr$!) do |xval|
  expect(@stderr_text).to match(Regexp.new(xval))
end

When(%r!^I (?:query|invoke) (?:attribute|method) ["']?([_A-Za-z0-9?]+)["']?\((.*?)\)["']?$!) do |attr,args|
  args		= eval("[#{args}]")
  wrap_exception do
    Fibonaccia.send(attr.to_sym, *args)
  end
end

When(%r!^I (?:query|invoke) (?:attribute|method) ["']?\[(.*)\]["']?$!) do |args|
  args		= eval("[#{args}]")
  wrap_exception do
    Fibonaccia.send(:[], *args)
  end
end

When(%r!^I (?:query|invoke) (?:attribute|method) ["']?([_A-Za-z0-9?]+)["']?$!) do |attr|
  wrap_exception do
    Fibonaccia.send(attr.to_sym)
  end
end

When(%r!^I set (?:attribute|the)?\s*["']?([_A-Za-z0-9]+)["']? to (.+?)$!) do |attr,val|
  wrap_exception do
    Fibonaccia.send((attr. + '=').to_sym, eval(val))
  end
end

