Before() do
  @exemplar		= Fibonaccia
  @exception_raised	= nil
  @dirs			= [
                           'tmp/aruba',
                          ]
end                             # Before

Before('@reset_before') do |s|
  debugger
  @exemplar.reset
end
