#
# 
#
Then(%r!^it should raise an exception of type (\S+)$!) do |xval|
  expect(@exception_raised.class).to eq(eval(xval))
end
Then(%r!^it should raise an exception of type:$!) do |xval|
  expect(@exception_raised.class).to eq(eval(xval))
end
