#
#
#
Then(%r!^it should raise an exception of type (\S+)$!) do |xval|
  expect(@exception_raised.kind_of?(eval(xval))).to eq(true)
end
Then(%r!^it should raise an exception of type:$!) do |xval|
  expect(@exception_raised.kind_of?(eval(xval))).to eq(true)
end

Then(%r!^it should raise an exception with exc.to_s containing ["'](.*)["']$!) do |xval|
  expect(@exception_raised.to_s).to match(Regexp.new(xval))
end
Then(%r!^it should raise an exception with exc.to_s containing:$!) do |xval|
  expect(@exception_raised.to_s).to match(Regexp.new(xval))
end

Then(%r!^it should raise an exception with exc.to_str containing ["'](.*)["']$!) do |xval|
  expect(@exception_raised).to match(Regexp.new(xval))
end
Then(%r!^it should raise an exception with exc.to_str containing:$!) do |xval|
  expect(@exception_raised).to match(Regexp.new(xval))
end
