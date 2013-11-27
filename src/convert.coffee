define [], ->
  class Convert
    numberToString: (number) ->
      number /= 16.0
      "#{number}"


