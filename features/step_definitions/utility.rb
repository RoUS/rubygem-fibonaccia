#
# Cucumber steps of semi-general utility.
#

#
# Run a command and record any exception.
#
Given(%r!^I run system\("([^"]+)"\)$!) do |xval|
  wrap_exception do
    system(xval)
  end
end

Then(%r!^the return value should be a kind of (\S+)$!) do |xval|
  expect(@return_value.kind_of?(eval(xval))).to eq(true)
end

Then(%r!^the return value should be a kind of:$!) do |xval|
  expect(@return_value.kind_of?(eval(xval))).to eq(true)
end

Then(%r!^the return value should NOT be a kind of (\S+)$!) do |xval|
  expect(@return_value.kind_of?(eval(xval))).not_to eq(true)
end

Then(%r!^the return value should NOT be a kind of:$!) do |xval|
  expect(@return_value.kind_of?(eval(xval))).not_to eq(true)
end

Then(%r!^the return value should be exactly (.*)$!) do |xval|
  expect(@return_value).to eq(eval(xval))
end

Then(%r!^the return value should be exactly:$!) do |xval|
  debugger
  expect(@return_value).to eq(eval(xval))
end

Then(%r!^the return value should match ['"]?(.*)['"]?$!) do |xval|
  expect(@return_value).to match(%r!#{xval}!)
end

Then(%r!^the return value should NOT match ['"]?(.*)['"]?$!) do |xval|
  expect(@return_value).not_to match(%r!#{xval}!)
end

Then(%r!^the return value should include (\S+)$!) do |xval|
  expect(@return_value.include?(eval(xval))).to eq(true)
end

Then(%r!^the return value should include:$!) do |xval|
  expect(@return_value.include?(eval(xval))).to eq(true)
end

Then(%r!^the value of attribute ["']([_A-Za-z][_A-Za-z0-9]*)["'] should be exactly (["']?.*?["']?)$!) do |mname,xval|
  attr_value	= wrap_exception { @exemplar.send(mname) }
  expect(attr_value).to eq(eval(xval))
end
