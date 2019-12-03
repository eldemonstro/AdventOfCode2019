text = File.open(__dir__ + '/input.txt').read

input_frozen = text.chomp.split(',').map(&:to_i).freeze

nouns = (0..99)
verbs = (0..99)

stop = false

nouns.each do |noun|
  verbs.each do |verb|
    input = input_frozen.dup
    input[1] = noun
    input[2] = verb

    input.each_slice(4) do |op_code, pos_x, pos_y, pos_result|
      x = input[pos_x]
      y = input[pos_y]

      if op_code == 99
        break
      elsif op_code == 1
        input[pos_result] = x + y
      elsif op_code == 2
        input[pos_result] = x * y
      end
    end

    if input[0] == 19690720
      puts "noun #{noun}, verb #{verb}, result #{100 * noun + verb}"

      stop = true
    end
  end

  if stop
    break
  end
end

