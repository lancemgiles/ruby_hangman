def check_guess?(g)
  if answer.any? {|c| c == g}
    correct_guesses.push(g)
    answer.each_index do |i|
      if answer[i] == g
        self.answer_mask[i] = g
        true
      end
    end
  else
    incorrect_guesses.push(g)
    false
  end
end

answer = "answer"